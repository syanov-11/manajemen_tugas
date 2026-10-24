class Task {
  int? id;
  String mataKuliah;
  String judul;
  String deskripsi;
  String deadline;
  String prioritas;
  String status;

  Task({
    this.id,
    required this.mataKuliah,
    required this.judul,
    required this.deskripsi,
    required this.deadline,
    required this.prioritas,
    this.status = 'Belum', // Belum, Proses, Selesai[cite: 5]
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mataKuliah': mataKuliah,
      'judul': judul,
      'deskripsi': deskripsi,
      'deadline': deadline,
      'prioritas': prioritas,
      'status': status,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      mataKuliah: map['mataKuliah'],
      judul: map['judul'],
      deskripsi: map['deskripsi'],
      deadline: map['deadline'],
      prioritas: map['prioritas'],
      status: map['status'],
    );
  }
}
