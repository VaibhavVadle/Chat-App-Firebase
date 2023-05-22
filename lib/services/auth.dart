import 'package:chat_app_demo/modal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserId _userFromFirebaseUser(User user) {
    return UserId(userId: user.uid);
  }

  Future signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User firebaseUser = result.user!;
      debugPrint('Result: $result , $firebaseUser');
      return _userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User firebaseUser = result.user!;
      debugPrint('Result: $result');
      debugPrint('FireBase User: $firebaseUser');
      return _userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future resetPassword({required String email}) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
      // print('User Logout');
    } on FirebaseAuthException catch (e) {
      debugPrint('Error: $e');
    }
  }
}
