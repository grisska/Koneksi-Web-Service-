import 'package:flutter/material.dart'; // Import package yang diperlukan untuk membuat UI.
import 'package:http/http.dart' as http; // Import package yang diperlukan untuk melakukan permintaan HTTP.
import 'dart:convert'; // Import package yang diperlukan untuk mengonversi data JSON.

void main() {
  runApp(const MyApp()); // Menjalankan aplikasi Flutter.
}

// Menampung data hasil pemanggilan API
class Activity {
  String aktivitas; // Menyimpan nama aktivitas.
  String jenis; // Menyimpan jenis aktivitas.

  Activity({required this.aktivitas, required this.jenis}); // Konstruktor untuk inisialisasi objek Activity.

  // Map dari json ke atribut
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'], // Mendapatkan nilai 'activity' dari JSON.
      jenis: json['type'], // Mendapatkan nilai 'type' dari JSON.
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Membuat state untuk objek MyApp.
  }
}

class MyAppState extends State<MyApp> {
  late Future<Activity> futureActivity; // Variabel untuk menyimpan hasil panggilan API.

  String url = "https://www.boredapi.com/api/activity"; // URL untuk melakukan panggilan API.

  // Metode untuk menginisialisasi futureActivity dengan objek Activity kosong.
  Future<Activity> init() async {
    return Activity(aktivitas: "", jenis: ""); // Inisialisasi futureActivity dengan objek Activity kosong.
  }

  // Metode untuk melakukan panggilan API dan mengonversi data JSON ke objek Activity.
  Future<Activity> fetchData() async {
    final response = await http.get(Uri.parse(url)); // Melakukan panggilan GET ke URL API.
    if (response.statusCode == 200) {
      // Jika server merespons dengan 200 OK (berhasil), parse JSON.
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // Jika gagal (tidak 200 OK), lempar exception.
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity = init(); // Inisialisasi futureActivity dengan objek Activity kosong.
  }

  @override
  Widget build(Object context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  futureActivity = fetchData(); // Memperbarui futureActivity dengan hasil panggilan API terbaru.
                });
              },
              child: Text("Saya bosan ..."), // Teks untuk tombol.
            ),
          ),
          FutureBuilder<Activity>(
            future: futureActivity,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika future telah selesai, tampilkan hasil aktivitas dan jenis.
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!.aktivitas),
                      Text("Jenis: ${snapshot.data!.jenis}")
                    ]));
              } else if (snapshot.hasError) {
                // Jika terjadi error, tampilkan pesan error.
                return Text('${snapshot.error}');
              }
              // Default: tampilkan loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    ));
  }
}
