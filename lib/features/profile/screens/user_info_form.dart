import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../home/screens/home_screen.dart';

class UserInfoForm extends StatefulWidget {
  const UserInfoForm({super.key});

  @override
  State<UserInfoForm> createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String age = '';
  String state = '';
  String reservation = '';
  String sector = '';

  Future<void> _saveUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'age': int.tryParse(age),
      'state': state,
      'reservation': reservation,
      'sector': sector,
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Welcome to YojnaMitr!")));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome! Tell us about you")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (val) => name = val!.trim(),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onSaved: (val) => age = val!.trim(),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'State'),
                onSaved: (val) => state = val!.trim(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Reservation Category'),
                onSaved: (val) => reservation = val!.trim(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Profession / Sector'),
                onSaved: (val) => sector = val!.trim(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _saveUserData();
                  }
                },
                child: const Text("Continue"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
