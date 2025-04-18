// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    // timeInSecForIosWeb: 1,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

ShowLoderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Builder(builder: (context) {
      return SizedBox(
        width: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: Colors.red,
            ),
            const SizedBox(
              height: 18,
            ),
            Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      );
    }),
  );

  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}

String getMessageFromErrorCode(String errorCode) {
  switch (errorCode) {
    case 'ERROR_EMAIL_ALREADY_IN_USE':
      return 'Email already used go to login page';
    case 'account-exists-with-different-cridentials':
      return 'Email already used go to login page';
    case 'email-already-in-use':
      return 'Email already used go to login page';
    case 'ERROR_WRONG_PASSWORD':
    case 'wrong-password':
      return 'Wrong password';
    case 'ERROR_USER_NOT_FOUND':
      return 'No user found with this email';
    case 'user-not-found':
      return 'No user found with this email';
    case 'ERROR_USER_DISABLED':
      return 'User disabled';
    case 'user-disabled':
      return 'User disabled';
    case 'ERROR_TOO_MANY_REQUESTS':
      return 'Too many requests to login to this account';
    case 'operation-not-allowed':
      return 'Too many requests to login to this account';
    case 'OPERATION_NOT_ALLOWED':
      return 'Too many requests to login to this account';
    case 'ERROR_INVALID_EMAIL':
      return ' email address is invalid';
    case 'invalid-email':
      return 'email address is invalid';
    default:
      return 'Login failed. Please try again';
  }
}

bool loginValidation(String email, String password) {
  if (email.isEmpty && password.isEmpty) {
    showMessage('Both fields are empty');
    return false;
  } else if (email.isEmpty) {
    showMessage('Email field is empty');
    return false;
  } else if (password.isEmpty) {
    showMessage('Password field is empty');
    return false;
  } else {
    return true;
  }
}

bool signValidation(String email, String password, String name, String phone) {
  if (email.isEmpty && password.isEmpty && name.isEmpty && phone.isEmpty) {
    showMessage('All fields are empty');
    return false;
  } else if (email.isEmpty) {
    showMessage('Email field is empty');
    return false;
  } else if (password.isEmpty) {
    showMessage('Password field is empty');
    return false;
  } else if (name.isEmpty) {
    showMessage('Name field is empty');
    return false;
  } else if (phone.isEmpty) {
    showMessage('Phone field is empty');
    return false;
  } else {
    return true;
  }
}
