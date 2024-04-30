import 'package:flutter/material.dart'; // Package untuk membuat aplikasi Flutter
import 'package:http/http.dart' as http; // Package untuk melakukan permintaan HTTP
import 'dart:convert'; // Package untuk mengubah data JSON ke Dart

// Kelas untuk menyimpan informasi tentang sebuah universitas
class UnivPage {
  String name; // Simpan nama universitas
  String alphaTwoCode; // Simpan kode dua huruf universitas
  String country; // Simpan negara universitas
  List<String> domains; // Simpan domain universitas
  List<String> webPages; // Simpan halaman web universitas

  // Konstruktor untuk menginisialisasi objek UnivPage
  UnivPage({required this.name, required this.alphaTwoCode, required this.country, required this.domains, required this.webPages});
}

// Kelas untuk menyimpan daftar informasi universitas
class Univ {
  List<UnivPage> ListPop = <UnivPage>[]; // Buat daftar kosong untuk simpan informasi

  // Konstruktor untuk menginisialisasi objek Univ dari data JSON
  Univ(List<dynamic> json) {
    // Looping untuk mengonversi data JSON ke objek UnivPage
    for (var val in json) {
      // Ubah data JSON ke atribut objek UnivPage
      var name = val["name"];
      var alphaTwoCode = val["alpha_two_code"];
      var country = val["country"];
      var domains = List<String>.from(val["domains"]);
      var webPages = List<String>.from(val["web_pages"]);
      // Tambahkan objek UnivPage ke daftar
      ListPop.add(UnivPage(name: name, alphaTwoCode: alphaTwoCode, country: country, domains: domains, webPages: webPages));
    }
  }

  // Metode factory untuk mengubah data JSON menjadi objek Univ
  factory Univ.fromJson(List<dynamic> json) {
    return Univ(json);
  }
}

void main() {
  runApp(MyApp()); // Jalankan aplikasi Flutter
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Buat status untuk objek MyApp
  }
}

class MyAppState extends State<MyApp> {
  late Future<Univ> futurePopulasi; // Simpan hasil data universitas

  String url = "http://universities.hipolabs.com/search?country=Indonesia"; // URL untuk permintaan API

  // Fungsi untuk mengambil data universitas dari API
  Future<Univ> fetchData() async {
    // Permintaan GET ke URL API
    final response = await http.get(Uri.parse(url));
    // Jika respons dari server 200 OK, ubah JSON ke objek Univ
    if (response.statusCode == 200) {
      return Univ.fromJson(jsonDecode(response.body));
    } else {
      // Jika respons bukan 200 OK, lempar exception
      throw Exception('Gagal memuat data');
    }
  }

  @override
  void initState() {
    super.initState();
    futurePopulasi = fetchData(); // Inisialisasi futurePopulasi dengan objek Univ kosong
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Populasi Universitas', // Judul aplikasi
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Populasi Universitas'), // Judul untuk appBar
        ),
        body: Center(
          child: FutureBuilder<Univ>(
            future: futurePopulasi,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: ListView.builder(
                    itemCount: snapshot.data!.ListPop.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 234, 250, 187),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 233, 241, 168).withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Nama: ${snapshot.data!.ListPop[index].name}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Kode: ${snapshot.data!.ListPop[index].alphaTwoCode}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Negara: ${snapshot.data!.ListPop[index].country}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Domains: ${snapshot.data!.ListPop[index].domains.join(', ')}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Web Pages: ${snapshot.data!.ListPop[index].webPages.join(', ')}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                );
              }
              return CircularProgressIndicator(); // Tampilkan spinner jika data belum ada
            },
          ),
        ),
      ),
    );
  }
}
