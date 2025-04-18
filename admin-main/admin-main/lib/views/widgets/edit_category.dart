// Import statements

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditCategoryScreen extends StatefulWidget {
  final QueryDocumentSnapshot categoryData;

  const EditCategoryScreen({Key? key, required this.categoryData})
      : super(key: key);

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.categoryData['name'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              width: 120,
              child: Image.network(
                widget.categoryData['image'],
              ),
            ),

            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Category Name'),
            ),

            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                _updateCategory();
              },
              child: Text('Update Category'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateCategory() async {
    String newName = _nameController.text;

    // Update the category details in Firestore
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryData.id)
        .update({
      'name': newName,
      // You can update other fields as needed
    });

    Navigator.of(context).pop(); // Close the edit screen
  }
}



// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';
// import 'dart:typed_data';

// import 'package:admin/constants/constants.dart';
// import 'package:admin/constants/primary_button.dart';
// import 'package:admin/controllers/firebase_storage_helper.dart';
// import 'package:admin/models/catagory_model.dart';
// import 'package:admin/provider/app_provider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// class EditCategory extends StatefulWidget {
//   final CategoryModel categoryModel;
//   final int index;
//   const EditCategory(
//       {super.key, required this.categoryModel, required this.index});

//   @override
//   State<EditCategory> createState() => _EditCategoryState();
// }

// class _EditCategoryState extends State<EditCategory> {
//   File? image;
//   void takePicture() async {
//     XFile? value = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (value != null) {
//       setState(() {
//         image = File(value.path);
//       });
//     }
//   }

//   TextEditingController name = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(
//       context,
//     );
//     return Scaffold(
//       appBar: AppBar(title: const Text('Category edit')),
//       body: ListView(
//         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//         children: [
//           image == null
//               ? CupertinoButton(
//                   onPressed: () {
//                     takePicture();
//                   },
//                   child: const CircleAvatar(
//                       backgroundColor: Colors.grey,
//                       radius: 50,
//                       child: Icon(Icons.camera_alt)),
//                 )
//               : CupertinoButton(
//                   onPressed: () {
//                     takePicture();
//                   },
//                   child: CircleAvatar(
//                     radius: 55,
//                     backgroundImage: FileImage(image!),
//                   ),
//                 ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: name,
//             decoration: InputDecoration(
//                 fillColor: Colors.white,
//                 filled: true,
//                 hintText: widget.categoryModel.name),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//               child: PrimaryButton(
//                   onPressed: () async {
//                     if (image == null && name.text.isEmpty) {
//                       Navigator.of(context).pop();
//                     } else if (image != null) {
//                       String imageUrl = await FirebaseStorageHelper.instance
//                           .uploadCategoryImage(
//                               widget.categoryModel.id, image! as Uint8List);
//                       CategoryModel categoryModel =
//                           widget.categoryModel.copyWith(
//                         image: imageUrl,
//                         name: name.text.isEmpty ? null : name.text,
//                       );
//                       appProvider.updateCategoryList(
//                           widget.index, categoryModel);
//                       showMessage('Category successfuly updated');
//                     } else {
//                       CategoryModel categoryModel =
//                           widget.categoryModel.copyWith(
//                         name: name.text.isEmpty ? null : name.text,
//                       );
//                       appProvider.updateCategoryList(
//                           widget.index, categoryModel);
//                       showMessage('Category successfully updated');
//                     }
//                     Navigator.of(context).pop();
//                     //   appProvider.updateUserInfoFirebase(
//                     //   context, userModel, image);
//                   },
//                   title: 'Update'))
//         ],
//       ),
//     );
//   }
// }
