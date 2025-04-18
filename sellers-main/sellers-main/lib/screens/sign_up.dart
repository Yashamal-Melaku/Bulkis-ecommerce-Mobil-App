// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers/constants/constants.dart';
import 'package:sellers/constants/routes.dart';
import 'package:sellers/controllers/firebase_auth_helper.dart';
import 'package:sellers/screens/login.dart';
import 'package:sellers/widgets/bottom_bar.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool isShowPassword = false;
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController conformPassword = TextEditingController();
  TextEditingController zone = TextEditingController();
  TextEditingController woreda = TextEditingController();
  TextEditingController kebele = TextEditingController();
  List<String> role = ['seller', 'delivery'];
  String? _selectedRole;

  String? countryValue;
  String? stateValue;

  String? cityValue;

  File? idCard;
  File? profile;

  void takePicture(void Function(File?) updateFile) async {
    XFile? value = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (value != null) {
      setState(() {
        updateFile(File(value.path));
      });
    }
  }

  void takeIdCardPicture() {
    takePicture((File? newIdCard) {
      idCard = newIdCard;
    });
  }

  void takeProfilePicture() {
    takePicture((File? newProfile) {
      profile = newProfile;
    });
  }

  // File? idCard;
  // File? profile;
  // void takeIdCardPicture() async {
  //   XFile? value = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (value != null) {
  //     setState(() {
  //       idCard = File(value.path);
  //     });
  //   }
  // }

  // void takeProfilePictur() async {
  //   XFile? value = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (value != null) {
  //     setState(() {
  //       profile = File(value.path);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Employee Registration'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //Icon(Icons.arrow_back),
                idCard == null
                    ? CupertinoButton(
                        onPressed: () {
                          takeIdCardPicture();
                        },
                        child: const CircleAvatar(
                          radius: 55,
                          child: Icon(Icons.camera_alt),
                        ),
                      )
                    : CupertinoButton(
                        onPressed: () {
                          takeIdCardPicture();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: Image.file(idCard!),
                        ),
                      ),

                Container(
                  child: profile == null
                      ? CupertinoButton(
                          onPressed: () {
                            takeProfilePicture();
                          },
                          child: const CircleAvatar(
                            radius: 55,
                            child: Icon(Icons.camera_alt),
                          ),
                        )
                      : CupertinoButton(
                          onPressed: () {
                            takeProfilePicture();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            child: Image.file(profile!),
                          ),
                        ),
                ),
                SizedBox(
                  height: 12,
                ),

                TextFormField(
                  controller: firstName,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'First name ',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter first name';
                    }
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: middleName,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Middle Name ',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter middle name';
                    }
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: lastName,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Last name ',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter last name';
                    }
                  },
                ),
                SizedBox(
                  height: 12,
                ),

                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'E-mail ',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter email address';
                    }
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter phone number';
                    }
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: password,
                  obscureText: isShowPassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter password ';
                    }
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: conformPassword,
                  obscureText: isShowPassword,
                  decoration: InputDecoration(
                    hintText: 'Conform password',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
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
                SizedBox(height: 20),
                CSCPicker(
                  showStates: true,

                  showCities: true,

                  flagState: CountryFlag.DISABLE,

                  dropdownDecoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),

                  disabledDropdownDecoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey.shade300,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),

                  ///placeholders for dropdown search field
                  countrySearchPlaceholder: "Country",
                  stateSearchPlaceholder: "State",
                  citySearchPlaceholder: "City",

                  ///labels for dropdown
                  countryDropdownLabel: "Country",
                  stateDropdownLabel: "Region",
                  cityDropdownLabel: "City",

                  ///Default Country
                  defaultCountry: CscCountry.Ethiopia,

                  selectedItemStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),

                  dropdownHeadingStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),

                  dropdownItemStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),

                  dropdownDialogRadius: 10.0,

                  searchBarRadius: 10.0,

                  onCountryChanged: (value) {
                    setState(() {
                      countryValue = value;
                    });
                  },

                  onStateChanged: (value) {
                    setState(() {
                      stateValue = value;
                    });
                  },

                  onCityChanged: (value) {
                    setState(() {
                      cityValue = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: zone,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Zone Address ',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: woreda,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Woreda address ',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: kebele,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Kebele Address ',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                SizedBox(height: 12),
                DropdownButtonFormField(
                  dropdownColor: Colors.white,
                  value: _selectedRole,
                  hint: Text('Sellect your applying role'),
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                  items:
                      role.map<DropdownMenuItem<String>>((String selectedUnit) {
                    return DropdownMenuItem<String>(
                      value: selectedUnit,
                      child: Text(selectedUnit),
                    );
                  }).toList(),
                ),

                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 2, 2, 2),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool isValidate = signValidation(
                          email.text,
                          password.text,
                          lastName.text,
                          phone.text,
                        );
                        if (isValidate) {
                          bool isRegistered =
                              await FirebaseAuthHelper.instance.signUp(
                            idCard!,
                            profile!,
                            firstName.text,
                            middleName.text,
                            lastName.text,
                            phone.text,
                            email.text,
                            password.text,
                            countryValue!,
                            stateValue!,
                            cityValue!,
                            zone.text,
                            woreda.text,
                            kebele.text,
                            _selectedRole!,
                            context,
                          );

                          if (isRegistered) {
                            // After successful registration, set the user role
                            await _setUserRole(_selectedRole!);

                            Routes.instance.pushAndRemoveUntil(
                              widget: CustomBottomBar(),
                              context: context,
                            );
                          }
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.green.shade400),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Text('OR'),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Routes.instance.push(widget: Login(), context: context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey.shade700),
                      // No need to set width here
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _setUserRole(String role) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Set custom claims for the user
      // await user!.({'role': role});

      // Update the user's ID token to include custom claims
      //await user.getIdToken(true);
    } catch (e) {
      print('Error setting user role: $e');
    }
  }
}
