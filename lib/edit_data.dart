import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:manajementugas/list_data.dart';
import 'package:manajementugas/side_menu.dart';

class EditData extends StatefulWidget {
  const EditData(
      {Key? key, required this.matkul, required this.tugas, required this.deadline})
      : super(key: key);
  final String matkul;
  final String tugas;
  final String deadline;
  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  final TextEditingController matkulController = TextEditingController();
  final TextEditingController tugasController = TextEditingController();

  Future updateData(String matkul, String tugas) async {
    final baseUrl = Platform.isAndroid
        ? 'http://10.98.5.189/api-flutter/index.php'
        : 'http://localhost/api-flutter/index.php';

    final headers = <String, String>{'Content-Type': 'application/json'};
    final requestBody = <String, dynamic>{
      'deadline': widget.deadline,
      'matkul': matkul,
      'tugas': tugas,
    };

    final response = await http.put(
      Uri.parse(baseUrl),
      headers: headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to update data');
    }
  }

  @override
  void initState() {
    super.initState();
    matkulController.text = widget.matkul;
    tugasController.text = widget.tugas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Tugas'),
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
              onPressed: () async {
                final matkul = matkulController.text;
                final tugas = tugasController.text;

                final result = await updateData(matkul, tugas);

                if (result['pesan'] == 'berhasil') {
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Data berhasil di update'),
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
                    },
                  );
                }
                setState(() {});
              },
              child: const Text('Update Tugas'),
            )
          ],
        ),
      ),
    );
  }
}
