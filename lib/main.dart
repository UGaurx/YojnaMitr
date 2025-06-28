import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



// Screens
import 'features/splash/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const YojnaMitrApp());
}

class YojnaMitrApp extends StatelessWidget {
  const YojnaMitrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YojnaMitr',
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // 🌗 Auto dark/light based on system
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true), 
    );
  }
}
