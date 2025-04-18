// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sellers/constants/constants.dart';
import 'package:sellers/constants/custom_snackbar.dart';
import 'package:sellers/constants/routes.dart';
import 'package:sellers/controllers/firebase_firestore_helper.dart';
import 'package:sellers/controllers/firebase_storage_helper.dart';
import 'package:sellers/delivery/delivery_home.dart';
import 'package:sellers/models/employee_model.dart';
import 'package:sellers/screens/home.dart';
import 'package:sellers/screens/landing_screen.dart';
import 'package:sellers/screens/login.dart';
import 'package:sellers/widgets/bottom_bar.dart';

class FirebaseAuthHelper {
  static FirebaseAuthHelper instance = FirebaseAuthHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFirestoreHelper _firestoreHelper = FirebaseFirestoreHelper();
  Stream<User?> get getAuthChange => _auth.authStateChanges();

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      ShowLoderDialog(context);

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance
          .collection('employees')
          .doc(user!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot.get('role') == "seller" ||
              documentSnapshot.get('role') == "delivery") {
            Routes.instance
                .push(widget: const CustomBottomBar(), context: context);
            customSnackbar(
                message: 'Sucessfully logined',
                context: context,
                backgroundColor: Colors.green.shade400,
                margin: 30,
                closTextColor: Colors.white);
          }
        } else {
          Routes.instance.push(widget: Login(), context: context);
          customSnackbar(
              message: 'Unable to login with this account to the application',
              context: context,
              backgroundColor: Colors.red,
              margin: 30,
              closTextColor: Colors.white);
          
        }
      });
      return true;
    } on FirebaseAuthException catch (error) {
      // showMessage(error.toString());
      Navigator.of(context).pop();

      return false;
    }
  }

  Future<bool> signUp(
    File idCard,
    File profile,
    String firstName,
    String middleName,
    String lastName,
    String phoneNumber,
    String email,
    String password,
    String country,
    String region,
    String city,
    String zone,
    String woreda,
    String kebele,
    String role,
    BuildContext context,
  ) async {
    try {
      ShowLoderDialog(context);

      UserCredential? userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentReference<Map<String, dynamic>> reference =
          FirebaseFirestore.instance.collection('employees').doc();

      String idCardUrl = await FirebaseStorageHelper.instance
          .uploadEmployeeIdCard(reference.id, idCard);

      String profileUrl = await FirebaseStorageHelper.instance
          .uploadEmployeeIdCard(reference.id, idCard);

      EmployeeModel employeeModel = EmployeeModel(
        employeeId: userCredential.user!.uid,
        idCard: idCardUrl,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        email: email,
        country: country,
        region: region,
        city: city,
        zone: zone,
        woreda: woreda,
        kebele: kebele,
        role: role,
        profile: profileUrl,
        approved: false,
      );
      Routes.instance.pushAndRemoveUntil(
          widget: const CustomBottomBar(), context: context);

      _firestore
          .collection('employees')
          .doc(employeeModel.employeeId)
          .set(employeeModel.toJson());

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

  Widget getHomeScreen() {
    return StreamBuilder<EmployeeModel>(
      stream: _firestoreHelper.getEmployeeInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          EmployeeModel? seller = snapshot.data;
          if (seller != null) {
            return (seller.role == 'delivery' && seller.approved == true)
                ? DeliveryHomeScreen()
                : (seller.role == 'seller' && seller.approved == true)
                    ? HomePage()
                    : LandingScreen();
          } else {
            return Login();
          }
        }
      },
    );
  }
}
