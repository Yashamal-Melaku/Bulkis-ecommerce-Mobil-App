// SignUp.dart
// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:buyers/constants/constants.dart';
import 'package:buyers/constants/custom_text.dart';
import 'package:buyers/constants/custome_button.dart';
import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/controllers/firebase_auth_helper.dart';
import 'package:buyers/screens/login.dart';
import 'package:buyers/screens/pin_input_screen.dart';
import 'package:buyers/widgets/bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isShowPassword = false;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  String verificationId = "";
  PhoneNumber? phoneNumber;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? initialCountry = 'ET';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                text(title: 'createAccount'.tr, size: 30, color: Colors.blue),
                SizedBox(height: 30),
                TextFormField(
                  controller: name,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'name'.tr,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'email'.tr,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                SizedBox(height: 30),
                InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    setState(() {
                      phoneNumber = number;
                    });
                  },
                  onInputValidated: (bool value) {
                    // Handle phone number validation if needed.
                  },
                  selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.DIALOG,
                    useBottomSheetSafeArea: true,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  selectorTextStyle: TextStyle(color: Colors.black),
                  initialValue: phoneNumber,
                  formatInput: false,
                  keyboardType: TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  inputDecoration: InputDecoration(
                    hintText: "Enter your phone number",
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: password,
                  obscureText: isShowPassword,
                  decoration: InputDecoration(
                    hintText: 'password'.tr,
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
                SizedBox(height: 50),

                CustomButton(
                  title: 'createAccount'.tr,
                  color: Colors.green,
                  onPressed: () async {
                    bool isValidate = signValidation(
                      email.text,
                      password.text,
                      name.text,
                      phoneNumber!.phoneNumber.toString(),
                    );

                    if (isValidate) {
                      bool isLogged = await FirebaseAuthHelper.instance.signUp(
                        name.text,
                        email.text,
                        password.text,
                        phoneNumber!.phoneNumber.toString(),
                        context,
                      );

                      if (isLogged) {
                        String phoneNumberString =
                            phoneNumber!.phoneNumber.toString();

                        await _firestore
                            .collection('users')
                            .doc(email.text)
                            .set({
                          'name': name.text,
                          'email': email.text,
                          'password': password.text,
                          'phoneNumber': phoneNumberString,
                        });

                        if (phoneNumber != null) {
                          await _verifyPhoneNumber(phoneNumberString);
                        } else {
                          Routes.instance.pushAndRemoveUntil(
                            widget: CustomBottomBar(),
                            context: context,
                          );
                        }
                      }
                    }
                  },
                ),

                // CustomButton(
                //   title: 'createAccount'.tr,
                //   color: Colors.green,
                //   onPressed: () async {
                //     bool isValidate = signValidation(email.text, password.text,
                //         name.text, phoneNumber!.phoneNumber.toString());

                //     if (isValidate) {
                //       bool islogined = await FirebaseAuthHelper.instance.signUp(
                //         name.text,
                //         email.text,
                //         password.text,
                //         phoneNumber.toString(),
                //         context,
                //       );
                //       if (islogined) {
                //         if (phoneNumber != null) {
                //           await _verifyPhoneNumber(phoneNumber!.phoneNumber!);
                //         } else {
                //           Routes.instance.pushAndRemoveUntil(
                //             widget: CustomBottomBar(),
                //             context: context,
                //           );
                //         }
                //       }
                //     }
                //   },
                // ),

                SizedBox(height: 20),
                Center(child: text(title: 'haveAccount'.tr)),
                SizedBox(height: 20),
                Center(
                  child: CupertinoButton(
                    onPressed: () {
                      Routes.instance.push(widget: Login(), context: context);
                    },
                    child: text(
                      title: 'login'.tr,
                      size: 20,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    try {
      await FirebaseAuthHelper.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        onVerificationCompleted: (AuthCredential credential) async {
          await FirebaseAuthHelper.instance.signInWithCredential(credential);
          Routes.instance.pushAndRemoveUntil(
            widget: CustomBottomBar(),
            context: context,
          );
        },
        onVerificationFailed: (FirebaseAuthException e) {
          print("Verification failed: $e");
        },
        onCodeSent: (String verificationId, int? resendToken) {
          setState(() {
            this.verificationId = verificationId;
          });

          // After receiving the verificationId, navigate to the PIN input screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CustomPinInput(verificationId: verificationId),
            ),
          );
        },
        onCodeAutoRetrievalTimeout: (String verificationId) {
          print("Auto retrieval timeout");
        },
        timeout: Duration(seconds: 60),
      );
    } catch (e) {
      print("Failed to verify phone number: $e");
    }
  }
}


// // ignore_for_file: prefer_const_constructors, use_build_context_synchronously

// import 'package:buyers/constants/constants.dart';
// import 'package:buyers/constants/custom_text.dart';
// import 'package:buyers/constants/custome_button.dart';
// import 'package:buyers/constants/custom_routes.dart';
// import 'package:buyers/controllers/firebase_auth_helper.dart';
// import 'package:buyers/screens/login.dart';
// import 'package:buyers/widgets/bottom_bar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/utils.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   bool isShowPassword = false;
//   TextEditingController name = TextEditingController();
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();
//   TextEditingController phone = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 text(title: 'createAccount'.tr, size: 30, color: Colors.blue),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 TextFormField(
//                   controller: name,
//                   keyboardType: TextInputType.name,
//                   decoration: InputDecoration(
//                     hintText: 'name'.tr,
//                     labelStyle: TextStyle(
//                         //   color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20),
//                     prefixIcon: Icon(Icons.person),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 TextFormField(
//                   controller: email,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(
//                     hintText: 'email'.tr,
//                     labelStyle: TextStyle(
//                         //  color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20),
//                     prefixIcon: Icon(Icons.email_outlined),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 TextFormField(
//                   controller: phone,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     hintText: 'phoneNumber'.tr,
//                     labelStyle: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20),
//                     prefixIcon: Icon(Icons.phone),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 TextFormField(
//                   controller: password,
//                   obscureText: isShowPassword,
//                   decoration: InputDecoration(
//                     hintText: 'password'.tr,
//                     labelStyle: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold),
//                     prefixIcon: Icon(
//                       Icons.lock,
//                       color: Colors.blue,
//                     ),
//                     suffixIcon: CupertinoButton(
//                       onPressed: () {
//                         setState(() {
//                           isShowPassword = !isShowPassword;
//                         });
//                       },
//                       child: Icon(
//                         isShowPassword
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 50,
//                 ),
//                 CustomButton(
//                   title: 'createAccount'.tr,
//                   color: Colors.green,
//                   onPressed: () async {
//                     bool isValidate = signValidation(
//                         email.text, password.text, name.text, phone.text);
//                     if (isValidate) {
//                       bool islogined = await FirebaseAuthHelper.instance.signUp(
//                           name.text, email.text, password.text, context);
//                       if (islogined) {
//                         Routes.instance.pushAndRemoveUntil(
//                             widget: CustomBottomBar(), context: context);
//                       }
//                     }
//                   },
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Center(child: text(title: 'haveAccount'.tr)),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Center(
//                   child: CupertinoButton(
//                       onPressed: () {
//                         Routes.instance.push(widget: Login(), context: context);
//                       },
//                       child: text(
//                           title: 'login'.tr, size: 20, color: Colors.blue)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
