// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// const String adminEmail = 'admin@admin.com'; // ✅ your admin email

// class AdminGuard extends StatelessWidget {
//   final Widget child;
//   const AdminGuard({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       return const Scaffold(
//         body: Center(child: Text("You must be logged in.")),
//       );
//     }

//     if (user.email != adminEmail) {
//       return const Scaffold(
//         body: Center(child: Text("Access denied. Admins only.")),
//       );
//     }

//     return child;
//   }
// }
