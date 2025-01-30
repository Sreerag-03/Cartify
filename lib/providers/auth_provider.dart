import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  AuthProvider() {
    _checkUser(); // Auto-login check on startup
  }

  User? get user => _user;

  Future<void> _checkUser() async {
    _user = _firebaseAuth.currentUser;
    notifyListeners();
  }

  // Sign Up
  Future<String?> signUp(String email, String password) async {
  try {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    _checkUser();
    return null;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return 'Password is too weak. Please choose a stronger one.';
    } else if (e.code == 'email-already-in-use') {
      return 'This email is already registered. Try logging in instead.';
    } else {
      return e.message;
    }
  }
}

  // Login
  Future<String?> signIn(String email, String password) async {
  try {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    _checkUser();
    return null;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return 'No account found for this email. Sign up instead.';
    } else if (e.code == 'wrong-password') {
      return 'Incorrect password. Please try again.';
    } else {
      return e.message;
    }
  }
}

  // Logout
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _user = null;
    notifyListeners();
  }
}
