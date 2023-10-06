import 'package:flutter/material.dart';
import 'package:manajementugas/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Manajemen Tugas',
      home: SplashScreen(),
    );
  }
}
