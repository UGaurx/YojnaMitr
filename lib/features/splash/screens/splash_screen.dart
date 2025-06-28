import 'dart:async';
import 'package:flutter/material.dart';
import '../../../auth_gate.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), _goToAuthGate);
  }

  void _goToAuthGate() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthGate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141218),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icon.png", width: 200, height: 200),
            const SizedBox(height: 16),
            // Text(
            //   "YojnaMitr",
            //   style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            //         color: Colors.white,
            //         fontWeight: FontWeight.bold,
            //       ),
            // ),
            // const SizedBox(height: 12),
            // const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
