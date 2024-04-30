import 'dart:convert';

void main() {
  // Data JSON mengenai informasi transkrip mahasiswa
  String transkripJson = '''
  {
    "nama": "Grisska Adelia",
    "nim": "22082010070",
    "mata_kuliah": [
      {
        "kode": "MK101",
        "nama": "Pemrograman Web",
        "sks": 3,
        "nilai": "A"
      },
      {
        "kode": "MK102",
        "nama": "Pemrograman Mobile",
        "sks": 3,
        "nilai": "A-"
      },
      {
        "kode": "MK103",
        "nama": "Statistika Komputasi",
        "sks": 3,
        "nilai": "B+"
      }
    ]
  }
  ''';

  // Mengurai JSON transkrip menjadi bentuk objek Dart menggunakan fungsi jsonDecode()
  Map<String, dynamic> transkrip = jsonDecode(transkripJson);

  // Menyimpan dan menampilkan nama dan NIM mahasiswa dari transkrip
  String nama = transkrip['nama']; //Nama mahasiswa
  String nim = transkrip['nim']; // NIM mahasiswa
  print('Nama Mahasiswa: $nama'); // Menampilkan nama mahasiswa
  print('NIM Mahasiswa: $nim'); // Menampilkan NIM mahasiswa

  // Menghitung IPK (Indeks Prestasi Kumulatif)
  List<dynamic> mataKuliah = transkrip['mata_kuliah']; // Mengambil daftar mata kuliah dari transkrip
  int totalSks = 0; // Inisialisasi total SKS menjadi 0
  double totalBobot = 0; // Inisialisasi total bobot menjadi 0

  print('\nNilai Mata Kuliah:'); // Menampilkan label untuk daftar nilai mata kuliah
  for (var mk in mataKuliah) { // Melakukan perulangan pada setiap mata kuliah dalam transkrip
    int sks = mk['sks']; // jumlah SKS untuk mata kuliah saat ini
    totalSks += sks; // Menambahkan jumlah SKS ke totalSks

    String kode = mk['kode']; // Mengambil kode mata kuliah
    String namaMataKuliah = mk['nama']; // Mengambil nama mata kuliah
    String nilai = mk['nilai']; // Mengambil nilai mata kuliah

    print('Mata Kuliah: $kode - $namaMataKuliah, Nilai: $nilai'); // Menampilkan  mata kuliah dan nilai

    double bobot = 0; // Inisialisasi bobot menjadi 0
    // Menentukan bobot berdasarkan nilai mata kuliah
    if (nilai == 'A') { // Jika nilai A, maka bobotnya 4.0
      bobot = 4.0;
    } else if (nilai == 'A-') { // Jika nilai A-, maka bobotnya 3.7
      bobot = 3.6;
    } else if (nilai == 'B+') { // Jika nilai B+, maka bobotnya 3.3
      bobot = 3.4;
    } 

    totalBobot += bobot * sks; // Menambahkan bobot mata kuliah ke totalBobot
  }

  double ipk = totalBobot / totalSks; // Menghitung IPK dengan membagi totalBobot dengan totalSks
  String formattedIpk = ipk.toStringAsFixed(2); // Memformat IPK menjadi dua angka di belakang koma
  print('\nTotal IPK Mahasiswa: $formattedIpk'); // Menampilkan total IPK mahasiswa
}
