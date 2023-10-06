import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:manajementugas/list_data.dart';
import 'package:manajementugas/side_menu.dart';

class TambahData extends StatefulWidget {
  const TambahData({Key? key}) : super(key: key);

  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final matkulController = TextEditingController();
  final tugasController = TextEditingController();

  Future postData(String matkul, String tugas) async {

    String url = Platform.isAndroid
        ? 'http://10.98.5.189/api-flutter/index.php'
        : 'http://localhost/api-flutter/index.php';
  
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody = '{"matkul": "$matkul", "tugas": "$tugas"}';
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Tugas'),
      ),
      drawer: const SideMenu(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: matkulController,
              decoration: const InputDecoration(
                hintText: 'matkul',
              ),
            ),
            TextField(
              controller: tugasController,
              decoration: const InputDecoration(
                hintText: 'tugas',
              ),
            ),
            ElevatedButton(
              child: const Text('Tambah Tugas'),
              onPressed: () {
                String matkul = matkulController.text;
                String tugas = tugasController.text;
                // print(matkul);
                postData(matkul, tugas).then((result) {
                  //print(result['pesan']);
                  if (result['pesan'] == 'berhasil') {
                    showDialog(
                        context: context,
                        builder: (context) {
          
                          return AlertDialog(
                            title: const Text('Data berhasil di tambah'),
                            content: const Text(''),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ListData(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        });
                  }
                  setState(() {});
                });
              },
            ),
          ],
        ),

      ),
    );
  }
}
