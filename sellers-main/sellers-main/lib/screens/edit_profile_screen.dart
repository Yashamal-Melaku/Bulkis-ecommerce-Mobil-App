// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:sellers/constants/primary_button.dart';
// import 'package:sellers/controllers/firebase_storage_helper.dart';
// import 'package:sellers/models/seller_model.dart';
// import 'package:sellers/providers/app_provider.dart';

// class EditProfile extends StatefulWidget {
//   const EditProfile({super.key});

//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }

// class _EditProfileState extends State<EditProfile> {
//   File? image;
//   void takePicture() async {
//     XFile? value = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (value != null) {
//       setState(() {
//         image = File(value.path);
//       });
//     }
//   }

//   TextEditingController firstName = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(
//       context,
//     );
//     FirebaseStorageHelper _storageHelper = FirebaseStorageHelper.instance;
//     return Scaffold(
//       appBar: AppBar(title: const Text('Profile Setting')),
//       body: ListView(
//         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//         children: [
//           if (image == null)
//             CupertinoButton(
//               onPressed: () {
//                 takePicture();
//               },
//               child: CircleAvatar(
//                   backgroundImage:
//                       NetworkImage(appProvider.getUserInformation.image!),
//                   radius: 50,
//                   child: Icon(Icons.camera_alt)),
//             )
//           else
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: FileImage(
//                 image!,
//               ),
//             ),
//           const SizedBox(height: 12),
//           TextFormField(
//             decoration: InputDecoration(
//                 fillColor: Colors.white,
//                 filled: true,
//                 hintText: appProvider.getUserInformation.firstName),
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: firstName,
//             decoration: InputDecoration(
//                 fillColor: Colors.white,
//                 filled: true,
//                 hintText: appProvider.getUserInformation.email),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//               child: CustomButton(
//                   onPressed: () async {
//                     String imageUrl =
//                         await _storageHelper.uploadSellerImage(image!);
//                     EmployeeModel EmployeeModel =
//                         appProvider.getUserInformation.copyWith(
//                       firstName: firstName.text.isEmpty ? null : firstName.text,
//                       image: imageUrl,
//                     );
//                     try {
//                       appProvider.updateUserInfoFirebase(
//                         context,
//                         EmployeeModel,
//                         image,
//                       );
//                     } catch (e) {
//                       print('Error updating user info: $e');
//                     }
//                   },
//                   title: 'Update'))
//         ],
//       ),
//     );
//   }
// }
