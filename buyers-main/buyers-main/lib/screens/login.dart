// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:buyers/constants/constants.dart';
import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/constants/custom_text.dart';
import 'package:buyers/constants/custome_button.dart';
import 'package:buyers/controllers/firebase_auth_helper.dart';
import 'package:buyers/screens/phone_auth_screen.dart';
import 'package:buyers/screens/sign_up.dart';
import 'package:buyers/widgets/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuthHelper _authHelper = FirebaseAuthHelper();
  bool isShowPassword = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 25),
            child: Column(
              children: [
                text(title: 'login'.tr, size: 30, color: Colors.blue),
                Container(
                    height: 200,
                    child: Image.asset('assets/images/buyers.jpg')),
                SizedBox(height: 20),
                Container(
                  color: Colors.white,
                  child: Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          color: Colors.grey,
                          child: CupertinoButton(
                            onPressed: () {
                              bool isLoagin = _authHelper.signInWithGoogle();
                              if (isLoagin) {
                                Routes.instance.pushAndRemoveUntil(
                                    widget: CustomBottomBar(),
                                    context: context);
                              }
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icons/google1.png',
                                  width: 30,
                                  height: 30,
                                ),
                                FittedBox(
                                    child: text(
                                  title: 'Google sign in',
                                  size: 16,
                                )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.green,
                          child: CupertinoButton(
                            onPressed: () {
                              // bool isLoagin = _authHelper.signInWithGoogle();
                              // if (isLoagin) {
                              Routes.instance.pushAndRemoveUntil(
                                  widget: PhoneAuthScreen(), context: context);
                              //}
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icons/phone.png',
                                  width: 30,
                                  height: 30,
                                ),
                                FittedBox(
                                    child:
                                        text(title: 'Phone sign in', size: 16)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    hintText: 'email'.tr,
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: password,
                  obscureText: isShowPassword,
                  decoration: InputDecoration(
                    hintText: 'password'.tr,
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.blue,
                    ),
                    suffixIcon: CupertinoButton(
                      onPressed: () {
                        setState(() {
                          isShowPassword = !isShowPassword;
                        });
                      },
                      child: Icon(
                        isShowPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomButton(
                    title: 'login'.tr,
                    color: Colors.green,
                    onPressed: () async {
                      bool isValidate =
                          loginValidation(email.text, password.text);
                      if (isValidate) {
                        bool islogined = await _authHelper.login(
                            email.text, password.text, context);
                        if (islogined) {
                          Routes.instance.pushAndRemoveUntil(
                              widget: CustomBottomBar(), context: context);
                        }
                      }
                    }),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text('noAccount'.tr),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: CupertinoButton(
                      onPressed: () {
                        Routes.instance
                            .push(widget: const SignUp(), context: context);
                      },
                      child: text(
                          title: 'createAccount'.tr,
                          size: 20,
                          color: Colors.blue)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
