import 'dart:io';

import 'package:buyers/constants/custome_button.dart';
import 'package:buyers/models/user_model.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? image;
  void takePicture() async {
    XFile? value = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }

  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(title: Text('profileSettings'.tr)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        children: [
          image == null
              ? CupertinoButton(
                  onPressed: () {
                    takePicture();
                  },
                  child: const CircleAvatar(
                      //  backgroundColor: Colors.grey,
                      radius: 50,
                      child: Icon(Icons.camera_alt)),
                )
              : CircleAvatar(
                  radius: 50,
                  backgroundImage: FileImage(
                    image!,
                  ),
                ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(
                // fillColor: Colors.white,
                filled: true,
                hintText: appProvider.getUserInformation.name),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: name,
            decoration: InputDecoration(
                //fillColor: Colors.white,
                filled: true,
                hintText: appProvider.getUserInformation.email),
          ),
          const SizedBox(height: 12),
          SizedBox(
              child: CustomButton(
                  onPressed: () async {
                    UserModel userModel = appProvider.getUserInformation
                        .copyWith(name: name.text);
                    appProvider.updateUserInfoFirebase(
                        context, userModel, image);
                  },
                  // color: Colors.green,
                  title: 'update'.tr))
        ],
      ),
    );
  }
}
