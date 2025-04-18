// ignore_for_file: use_build_context_synchronously

import 'package:buyers/constants/custom_text.dart';
import 'package:buyers/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomPinInput extends StatefulWidget {
  final String verificationId;

  const CustomPinInput({Key? key, required this.verificationId})
      : super(key: key);

  @override
  _CustomPinInputState createState() => _CustomPinInputState();
}

class _CustomPinInputState extends State<CustomPinInput> {
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //title: Text("Custom PIN Input"),
          ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          text(
            title: 'Authentication',
            size: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
            child: PinCodeTextField(
              appContext: context,
              length: 6,
              controller: _pinController,
              autoDisposeControllers: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeColor: Colors.blue,
                inactiveColor: Colors.grey,
                selectedColor: Colors.green,
              ),
              onChanged: (value) {},
              onCompleted: (value) async {
                try {
                  AuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: value,
                  );

                  await FirebaseAuth.instance.signInWithCredential(credential);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CustomBottomBar()),
                    (route) => false,
                  );
                } catch (e) {
                  print("Failed to sign in: $e");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


// class PinInputScreen extends StatefulWidget {
//   final String verificationId;
//   final void Function(String pin) onPinEntered;

//   PinInputScreen({
//     required this.verificationId,
//     required this.onPinEntered,
//   });

//   @override
//   _PinInputScreenState createState() => _PinInputScreenState();
// }

// class _PinInputScreenState extends State<PinInputScreen> {
//   TextEditingController _pinController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Enter PIN'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _pinController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'PIN',
//               ),
//               maxLength: 6, // Adjust as needed
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 String pin = _pinController.text;
//                 widget.onPinEntered(pin);
//               },
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
