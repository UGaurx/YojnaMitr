// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class UpdateFiltersForm extends StatefulWidget {
//   const UpdateFiltersForm({super.key});

//   @override
//   State<UpdateFiltersForm> createState() => _UpdateFiltersFormState();
// }

// class _UpdateFiltersFormState extends State<UpdateFiltersForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _statesCtrl = TextEditingController();
//   final _sectorsCtrl = TextEditingController();
//   final _eligibilityCtrl = TextEditingController();

//   Future<void> _submit() async {
//     final states = _statesCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
//     final sectors = _sectorsCtrl.text.split(',').map((e) => e.trim()).toList();
//     final eligibility = _eligibilityCtrl.text.split(',').map((e) => e.trim()).toList();

//     await FirebaseFirestore.instance.collection('filters').doc('options').set({
//       'states': states,
//       'sectors': sectors,
//       'eligibility': eligibility,
//     });

//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Filters updated")));
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Update Filter Options")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               const Text("Enter comma-separated values"),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _statesCtrl,
//                 decoration: const InputDecoration(labelText: 'States'),
//               ),
//               TextFormField(
//                 controller: _sectorsCtrl,
//                 decoration: const InputDecoration(labelText: 'Sectors'),
//               ),
//               TextFormField(
//                 controller: _eligibilityCtrl,
//                 decoration: const InputDecoration(labelText: 'Eligibility Tags'),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submit,
//                 child: const Text("Update Filters"),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
