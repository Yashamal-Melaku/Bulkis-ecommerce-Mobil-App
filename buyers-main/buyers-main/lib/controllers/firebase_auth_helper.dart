// ignore_for_file: use_build_context_synchronously

import 'package:buyers/constants/constants.dart';
import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/models/user_model.dart';
import 'package:buyers/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthHelper {
  static FirebaseAuthHelper instance = FirebaseAuthHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<User?> get getAuthChange => _auth.authStateChanges();

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      ShowLoderDialog(context);

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Routes.instance
          .pushAndRemoveUntil(widget: const Home(), context: context);
      Navigator.of(context).pop();
      return true;
    } on FirebaseAuthException catch (error) {
      showMessage(error.code.toString());
      return false;
    }
  }

  Future<bool> signUp(
    String name,
    String email,
    String password,
    String phoneNumber,
    BuildContext context,
  ) async {
    try {
      ShowLoderDialog(context);

      UserCredential? userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        image: null,
      );
      Routes.instance
          .pushAndRemoveUntil(widget: const Home(), context: context);

      _firestore.collection('users').doc(userModel.id).set(userModel.toJson());
      Navigator.of(context).pop();
      return true;
    } on FirebaseAuthException catch (error) {
      showMessage(error.code.toString());
      return false;
    }
  }

  void signOut() async {
    await _auth.signOut();
  }

  Future<bool> changePassword(String password, BuildContext context) async {
    try {
      ShowLoderDialog(context);

      _auth.currentUser!.updatePassword(password);

      Navigator.of(context, rootNavigator: true).pop();
      showMessage('Password changed');
      Navigator.of(context).pop();
      return true;
    } on FirebaseAuthException catch (error) {
      showMessage(error.code.toString());
      return false;
    }
  }

  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String verificationId) onCodeAutoRetrievalTimeout,
    required void Function(AuthCredential) onVerificationCompleted,
    required void Function(FirebaseAuthException) onVerificationFailed,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: onVerificationCompleted,
        verificationFailed: onVerificationFailed,
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
        timeout: timeout,
      );
    } catch (e) {
      print("Failed to verify phone number: $e");
    }
  }

  Future<void> signInWithCredential(AuthCredential credential) async {
    try {
      await _auth.signInWithCredential(credential);
      print("Successfully signed in");
    } catch (e) {
      print("Failed to sign in: $e");
      // Handle the failure, such as showing an error message
    }
  }
}
