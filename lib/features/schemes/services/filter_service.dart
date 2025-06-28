import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FilterService {
  final _filtersCollection = FirebaseFirestore.instance.collection('filters');

  Future<List<String>> getStates() async {
    try {
      final doc = await _filtersCollection.doc('options').get();
      final data = doc.data();
      if (data != null && data['states'] != null) {
        final List<dynamic> rawList = data['states'];
        return List<String>.from(rawList);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching states: $e");
      }
    }
    return [];
  }

  Future<List<String>> getSectors() async {
    try {
      final doc = await _filtersCollection.doc('options').get();
      final data = doc.data();
      if (data != null && data['sectors'] != null) {
        final List<dynamic> rawList = data['sectors'];
        return List<String>.from(rawList);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching sectors: $e");
      }
    }
    return [];
  }

  Future<List<String>> getEligibilityOptions() async {
    try {
      final doc = await _filtersCollection.doc('options').get();
      final data = doc.data();
      if (data != null && data['eligibility'] != null) {
        final List<dynamic> rawList = data['eligibility'];
        return List<String>.from(rawList);
      }
    } catch (e) {
        if (kDebugMode) {
          print("Error fetching eligibility options: $e");
        }
    }
    return [];
  }
}
