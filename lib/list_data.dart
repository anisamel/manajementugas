import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:manajementugas/edit_data.dart';
import 'package:manajementugas/side_menu.dart';
import 'package:manajementugas/tambah_data.dart';

class ListData extends StatefulWidget {
  const ListData({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  List<Map<String, String>> datamanajementugas = [];
  String url = Platform.isAndroid
      ? 'http://10.98.5.189/api-flutter/index.php'
      : 'http://localhost/api-flutter/index.php';
  // String url = 'http://localhost/api-flutter/index.php';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        datamanajementugas = List<Map<String, String>>.from(data.map((item) {
          return {
            'matkul': item['matkul'] as String,
            'tugas': item['tugas'] as String,
            'id': item['deadline'] as String,
          };
        }));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future deleteData(int deadline) async {
    final response = await http.delete(Uri.parse('$url?deadline=$deadline'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data manajementugas'),
      ),
      drawer: const SideMenu(),
      body: Column(children: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TambahData(),
              ),
            );
          },
          child: const Text('Tambah Data manajementugas'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: datamanajementugas.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(datamanajementugas[index]['matkul']!),
                subtitle: Text('tugas: ${datamanajementugas[index]['tugas']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.visibility),
                      onPressed: () {
                        lihatmanajementugas(context, index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        editmanajementugas(context, index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteData(int.parse(datamanajementugas[index]['deadline']!))
                            .then((result) {
                          if (result['pesan'] == 'berhasil') {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Data berhasil di hapus'),
                                    content: const Text(''),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ListData(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ]),
    );
  }

  void editmanajementugas(BuildContext context, int index) {
    final Map<String, dynamic> manajementugas = datamanajementugas[index];
    final String deadline = manajementugas['deadline'] as String;
    final String matkul = manajementugas['matkul'] as String;
    final String tugas = manajementugas['tugas'] as String;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditData(deadline: deadline, matkul: matkul, tugas: tugas),
    ));
  }

  void lihatmanajementugas(BuildContext context, int index) {
    final manajementugas = datamanajementugas[index];
    final matkul = manajementugas['matkul'] as String;
    final tugas = manajementugas['tugas'] as String;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          title: const Center(child: Text('Detail manajementugas')),
          content: SizedBox(
            height: 50,
            child: Column(
              children: [
                Text('matkul : $matkul'),
                Text('tugas: $tugas'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
