// lib/services/auth_service.dart

import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get userChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUpWithEmail(String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn.instance;

    // Initialize with correct client IDs
    if (kIsWeb) {
      await googleSignIn.initialize(
        clientId: '148781520294-146b7obuoec8n0b5fqksccm1miej0q59.apps.googleusercontent.com', // web client id
      );
    } else {
      await googleSignIn.initialize(
        clientId: Platform.isIOS
            ? 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com' // Replace with iOS client ID
            : null,
        serverClientId: '148781520294-146b7obuoec8n0b5fqksccm1miej0q59.apps.googleusercontent.com', // web client id for Android
      );
    }

    // Optional: Lightweight auth
    await googleSignIn.attemptLightweightAuthentication();

    final user = await googleSignIn.authenticate();
    if (user == null) {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted',
      );
    }

    final auth = await user.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: auth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }


  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();	
    await _auth.signOut();
  }
}
