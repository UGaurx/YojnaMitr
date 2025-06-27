import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSchemeForm extends StatefulWidget {
  const AddSchemeForm({super.key});

  @override
  State<AddSchemeForm> createState() => _AddSchemeFormState();
}

class _AddSchemeFormState extends State<AddSchemeForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '', description = '', state = '', sector = '', applyLink = '';
  List<String> eligibility = [];

  final _eligibilityController = TextEditingController();

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    await FirebaseFirestore.instance.collection('schemes').add({
      'name': name,
      'description': description,
      'state': state,
      'sector': sector,
      'applyLink': applyLink,
      'eligibility': eligibility,
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Scheme added")));
      Navigator.pop(context);
    }
  }

  void _addEligibilityTag() {
    final tag = _eligibilityController.text.trim();
    if (tag.isNotEmpty && !eligibility.contains(tag)) {
      setState(() {
        eligibility.add(tag);
        _eligibilityController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      eligibility.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Scheme")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Scheme Name'),
                onSaved: (val) => name = val!.trim(),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (val) => description = val!.trim(),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'State (or All)'),
                onSaved: (val) => state = val!.trim(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Sector'),
                onSaved: (val) => sector = val!.trim(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Apply Link'),
                onSaved: (val) => applyLink = val!.trim(),
              ),
              const SizedBox(height: 12),
              Text("Eligibility Tags"),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _eligibilityController,
                      decoration: const InputDecoration(hintText: "e.g. Farmer, SC"),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addEligibilityTag,
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: eligibility
                    .map((tag) => Chip(
                          label: Text(tag),
                          onDeleted: () => _removeTag(tag),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Submit Scheme"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
