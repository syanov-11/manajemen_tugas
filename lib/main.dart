import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'task_provider.dart';
import 'task_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => TaskProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manajemen Tugas',
      debugShowCheckedModeBanner: false, // Menghilangkan pita merah Debug
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor:
            Colors.grey[100], // Warna latar belakang abu-abu sangat muda
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
      home: TaskListScreen(),
    );
  }
}

// --- SCREEN 1: DAFTAR TUGAS ---
class TaskListScreen extends StatelessWidget {
  // Fungsi pembantu untuk memberi warna pada status
  Color _getStatusColor(String status) {
    if (status == 'Selesai') return Colors.green;
    if (status == 'Proses') return Colors.orange;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Tugas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: taskProvider.tasks.isEmpty
          ? Center(
              child: Text(
                'Belum ada tugas. Yuk tambah!',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    title: Text(
                      task.judul,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.book, size: 16, color: Colors.indigo),
                              SizedBox(width: 6),
                              Text(task.mataKuliah),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.timer,
                                size: 16,
                                color: Colors.redAccent,
                              ),
                              SizedBox(width: 6),
                              Text(
                                task.deadline,
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing: Chip(
                      label: Text(
                        task.status,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: _getStatusColor(task.status),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide.none,
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskDetailScreen(task: task),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        icon: Icon(Icons.add),
        label: Text('Tugas'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TaskFormScreen()),
        ),
      ),
    );
  }
}

// --- SCREEN 2: DETAIL TUGAS ---
class TaskDetailScreen extends StatelessWidget {
  final Task task;
  TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Tugas'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TaskFormScreen(task: task)),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Text('Hapus Tugas?'),
                  content: Text('Tugas yang dihapus tidak dapat dikembalikan.'),
                  actions: [
                    TextButton(
                      child: Text(
                        'Batal',
                        style: TextStyle(color: Colors.grey),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        'Hapus',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Provider.of<TaskProvider>(
                          context,
                          listen: false,
                        ).deleteTask(task.id!);
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.judul,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Divider(height: 30, thickness: 1),
                _buildDetailRow(Icons.book, 'Mata Kuliah', task.mataKuliah),
                SizedBox(height: 15),
                _buildDetailRow(Icons.description, 'Deskripsi', task.deskripsi),
                SizedBox(height: 15),
                _buildDetailRow(
                  Icons.calendar_month,
                  'Deadline',
                  task.deadline,
                  color: Colors.red,
                ),
                SizedBox(height: 15),
                _buildDetailRow(Icons.flag, 'Prioritas', task.prioritas),
                SizedBox(height: 15),
                _buildDetailRow(
                  Icons.info,
                  'Status',
                  task.status,
                  color: Colors.indigo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String title,
    String value, {
    Color color = Colors.black87,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey, size: 22),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey, fontSize: 14)),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- SCREEN 3: FORM TAMBAH/EDIT TUGAS ---
class TaskFormScreen extends StatefulWidget {
  final Task? task;
  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _mataKuliah, _judul, _deskripsi, _deadline, _prioritas, _status;

  @override
  void initState() {
    super.initState();
    _mataKuliah = widget.task?.mataKuliah ?? '';
    _judul = widget.task?.judul ?? '';
    _deskripsi = widget.task?.deskripsi ?? '';
    _deadline = widget.task?.deadline ?? '';
    _prioritas = widget.task?.prioritas ?? 'Sedang'; // Default Sedang
    _status = widget.task?.status ?? 'Belum';
  }

  InputDecoration _buildInputDeco(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.indigo),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.indigo, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Tambah Tugas' : 'Edit Tugas'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextFormField(
              initialValue: _mataKuliah,
              decoration: _buildInputDeco('Mata Kuliah', Icons.book),
              onSaved: (val) => _mataKuliah = val!,
            ),
            SizedBox(height: 16),
            TextFormField(
              initialValue: _judul,
              decoration: _buildInputDeco('Judul Tugas', Icons.title),
              onSaved: (val) => _judul = val!,
            ),
            SizedBox(height: 16),
            TextFormField(
              initialValue: _deskripsi,
              maxLines: 3,
              decoration: _buildInputDeco('Deskripsi', Icons.description),
              onSaved: (val) => _deskripsi = val!,
            ),
            SizedBox(height: 16),
            TextFormField(
              initialValue: _deadline,
              decoration: _buildInputDeco(
                'Deadline (contoh: 25 Okt)',
                Icons.calendar_month,
              ),
              onSaved: (val) => _deadline = val!,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              items: [
                'Belum',
                'Proses',
                'Selesai',
              ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => _status = val!),
              decoration: _buildInputDeco('Status', Icons.info),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Simpan Tugas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final newTask = Task(
                    id: widget.task?.id,
                    mataKuliah: _mataKuliah,
                    judul: _judul,
                    deskripsi: _deskripsi,
                    deadline: _deadline,
                    prioritas: _prioritas,
                    status: _status,
                  );

                  if (widget.task == null) {
                    Provider.of<TaskProvider>(
                      context,
                      listen: false,
                    ).addTask(newTask);
                  } else {
                    Provider.of<TaskProvider>(
                      context,
                      listen: false,
                    ).updateTask(newTask);
                  }
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
