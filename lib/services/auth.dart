import 'package:chatter/modal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FinalUser _userFromFirebase(User user) {
    return user != null
        ? FinalUser(
            userId: user.uid,
            userMail: user.email,
            userImage: user.photoURL,
            userdisplayName: user.displayName,
          )
        : null;
  }

  Future signInEP(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseuser = result.user;
      return _userFromFirebase(firebaseuser);
    } catch (e) {
      return null;
    }
  }

  Future signUpEP(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseuser = result.user;
      return _userFromFirebase(firebaseuser);
    } catch (e) {
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}

//!TODO firbase.init
