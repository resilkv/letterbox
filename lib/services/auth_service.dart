import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  User? get user => _auth.currentUser;


  bool get isAuthenticated => user != null;


  Future<String?> signUp(String email, String password) async {
  try {
    final cred = await _auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
    );
    notifyListeners();
    return cred.user?.uid;
        } on FirebaseAuthException catch (e) {
      return e.message;
      }
  }


  Future<String?> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
      );
      notifyListeners();
      return cred.user?.uid;
        } on FirebaseAuthException catch (e) {
        return e.message;
    }
  }


  Future<void> signOut() async {
  await _auth.signOut();
  notifyListeners();
  }
}