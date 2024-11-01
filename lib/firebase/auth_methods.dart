import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  var myId = "";
  AuthMethods() {
    getCurrentUserId();
  }
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential> createAccount(String email, String password) async {
    return auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> login(String email, String password) async {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential?> signInWithGoogle() async {
    if (!kIsWeb && Platform.isWindows) return null;
    //try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    final UserCredential userCredential =
        await auth.signInWithCredential(credential);
    return userCredential;
    // } on FirebaseException catch (e) {
    //   return null;
    // }
  }

  void addUser() {}

  Future<void> logOut() async {
    return auth.signOut();
  }

  Future<void> sendEmailVerification() async {
    final user = auth.currentUser;
    return user?.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    final user = auth.currentUser;
    return user?.emailVerified ?? false;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    return auth.sendPasswordResetEmail(email: email);
  }

  String getCurrentUserId() {
    myId = auth.currentUser?.uid ?? "";
    return myId;
  }

  Future<void> deleteAccount() async {
    final user = auth.currentUser;
    return user?.delete();
  }

  Future<bool> checkIfEmailExists(String email) async {
    final task = await auth.fetchSignInMethodsForEmail(email);
    return task.length == 1;
  }

  Future<bool> comfirmPassword(String password) async {
    final user = auth.currentUser;
    if (user == null) return false;
    try {
      final credential =
          EmailAuthProvider.credential(email: user.email!, password: password);
      final credentialresult =
          await user.reauthenticateWithCredential(credential);
      return credentialresult.user != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateEmail(String email) async {
    final user = auth.currentUser;
    return user?.verifyBeforeUpdateEmail(email);
  }

  Future<void> updatePassword(String password) async {
    final user = auth.currentUser;
    return user?.updatePassword(password);
  }

  Future<void> updateName(String? name) async {
    final user = auth.currentUser;
    return user?.updateDisplayName(name);
  }

  Future<void> updatePhotoUrl(String? photo_url) async {
    final user = auth.currentUser;
    return user?.updatePhotoURL(photo_url);
  }

  Future<void> updatePhoneNumber(String phone) async {
    final user = auth.currentUser;
    //user?.updatePhoneNumber(phone);
  }
}
