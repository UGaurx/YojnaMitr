import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String age = '';
  String state = '';
  String reservation = '';
  String sector = '';

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        name = data['name'] ?? '';
        age = data['age']?.toString() ?? '';
        state = data['state'] ?? '';
        reservation = data['reservation'] ?? '';
        sector = data['sector'] ?? '';
        _loading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': name,
      'age': int.tryParse(age),
      'state': state,
      'reservation': reservation,
      'sector': sector,
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context); // Go back to ProfileScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (val) => name = val!.trim(),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                initialValue: age,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onSaved: (val) => age = val!.trim(),
              ),
              TextFormField(
                initialValue: state,
                decoration: const InputDecoration(labelText: 'State'),
                onSaved: (val) => state = val!.trim(),
              ),
              TextFormField(
                initialValue: reservation,
                decoration: const InputDecoration(labelText: 'Reservation Category'),
                onSaved: (val) => reservation = val!.trim(),
              ),
              TextFormField(
                initialValue: sector,
                decoration: const InputDecoration(labelText: 'Sector / Profession'),
                onSaved: (val) => sector = val!.trim(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _saveProfile();
                  }
                },
                child: const Text("Save Changes"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
