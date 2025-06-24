import 'package:flutter/material.dart';

void main() {
  runApp(const YojnaMitrApp());
}

class YojnaMitrApp extends StatelessWidget {
  const YojnaMitrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YojnaMitr',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: Center(child: Text('Welcome to YojnaMitr!')),
      ),
    );
  }
}
