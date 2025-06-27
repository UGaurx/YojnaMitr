import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../schemes/models/scheme_model.dart';

class BookmarkService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  CollectionReference get _userBookmarks {
    final uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid).collection('bookmarks');
  }

  Future<void> addBookmark(Scheme scheme) {
    return _userBookmarks.doc(scheme.id).set(scheme.toMap());
  }

  Future<void> removeBookmark(String schemeId) {
    return _userBookmarks.doc(schemeId).delete();
  }

  Future<bool> isBookmarked(String schemeId) async {
    final doc = await _userBookmarks.doc(schemeId).get();
    return doc.exists;
  }

  Stream<List<Scheme>> getBookmarksStream() {
    return _userBookmarks.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Scheme.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }
}
