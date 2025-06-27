import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/scheme_model.dart';

class SchemeService {
  final _schemes = FirebaseFirestore.instance.collection('schemes');

  Future<List<Scheme>> fetchAllSchemes() async {
    final snapshot = await _schemes.get();
    return snapshot.docs.map((doc) => Scheme.fromMap(doc.data(), doc.id)).toList();
  }
}
