import 'package:flutter/material.dart';
import 'package:mis_lab1/screens/details.dart';
import 'package:mis_lab1/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Распоред за испити - 221253',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan.shade900),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const MyHomePage(title: 'Распоред за испити - 221253'),
        "/details": (context) => const DetailsPage(),
      },
    );
  }
}
