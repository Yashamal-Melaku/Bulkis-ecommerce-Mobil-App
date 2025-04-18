// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:admin/constants/constants.dart';
import 'package:admin/views/widgets/category_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  static const String routeName = '/CategoryScreen';

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic _image;

  String? fileName;
  late String categoryName;
  TextEditingController nameContorller = TextEditingController();

  _pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

  uploadCategoryImageToStorage(dynamic image) async {
    Reference ref = _storage.ref().child('CategoryImages').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print('Dounload url= $downloadUrl');
    return downloadUrl;
  }

  uploadCategory() async {
    if (_formKey.currentState!.validate()) {
      String imageUrl = await uploadCategoryImageToStorage(_image!);
      String docId = _firestore.collection('categories').doc().id;
      await _firestore.collection('categories').doc(docId).set(
        {
          'id': docId,
          'image': imageUrl,
          'name': categoryName,
        },
      );

      nameContorller.text = '';
      setState(() {
        _image = null;
      });

      showSnackBarMessage(
        context: context,
        message: 'Category Successfully Added',
        label: 'Ok',
        color: Colors.green.shade400,
        margin: 10,
      );
    } else {
      print('OH Bad Guy');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 12, 50, 12),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: _image == null ? 140 : 300,
                          width: _image == null ? 140 : 300,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                            //   border: Border.all(color: Colors.grey.shade800),
                          ),
                          child: _image != null
                              ? InkWell(
                                  onTap: () {
                                    _pickImage();
                                  },
                                  child: Image.memory(
                                    _image,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Positioned(
                                  right: 3,
                                  bottom: 20,
                                  child: FloatingActionButton(
                                      backgroundColor: Colors.white70,
                                      onPressed: () {
                                        _pickImage();
                                      },
                                      child: Icon(Icons.add_a_photo)),
                                ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: nameContorller,
                        onChanged: (value) {
                          categoryName = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter category Name ';
                          }
                          return null;
                        },
                        decoration:
                            InputDecoration(hintText: 'Enter Category Name'),
                      ),
                    ),
                    SizedBox(height: 12),
                    if (_image != null)
                      TextButton(
                          onPressed: () {
                            uploadCategory();
                          },
                          child: Text(
                            'Save Category',
                            style: TextStyle(color: Colors.green),
                          ))
                  ],
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Categories',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SingleChildScrollView(
                scrollDirection: Axis.vertical, child: CategoryWidget()),
          ],
        ),
      ),
    );
  }
}



















// ////================================================
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:admin/controllers/firebase_firestore_helper.dart';
// import 'package:admin/models/catagory_model.dart';
// import 'package:admin/provider/app_provider.dart';
// import 'package:admin/widgets/add_category.dart';
// import 'package:admin/widgets/single_category_item.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:provider/provider.dart';

// class CategoryViewScreen extends StatefulWidget {
//   static const String routeName = '/CategoryViewScreen';

//   @override
//   State<CategoryViewScreen> createState() => _CategoryViewScreenState();
// }

// class _CategoryViewScreenState extends State<CategoryViewScreen> {
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   FirebaseFirestoreHelper _firestoreHelper = FirebaseFirestoreHelper();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   dynamic _image;

//   String? fileName;
//   late String categoryName;
//   _pickImage() async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(allowMultiple: false, type: FileType.image);
//     if (result != null) {
//       setState(() {
//         _image = result.files.first.bytes;
//         fileName = result.files.first.name;
//       });
//       print('Image picked and set to _image.');
//     }
//   }

//   uploadCategoryBannerToStorage(dynamic image) async {
//     Uint8List bytes;
//     String imageName;

//     if (image is Uint8List) {
//       bytes = image;
//       imageName = fileName!;
//     } else if (image is File) {
//       bytes = await image.readAsBytes();
//       imageName = image.path.split('/').last;
//     } else {
//       throw Exception('Unsupported image type');
//     }

//     Reference ref = _storage.ref().child('CategoryImages').child(imageName);
//     UploadTask uploadTask = ref.putData(bytes);
//     TaskSnapshot snapshot = await uploadTask;
//     String downloadUrl = await snapshot.ref.getDownloadURL();
//     return downloadUrl;
//   }

//   uploadCategory() async {
//     try {
//       EasyLoading.show();
//       if (_formKey.currentState!.validate()) {
//         String imageUrl = await uploadCategoryBannerToStorage(_image);
//         await _firestoreHelper
//             .addSingleCategory(imageUrl as Uint8List, categoryName)
//             .then((value) {
//           EasyLoading.dismiss();
//           setState(() {
//             _image = null;
//             _formKey.currentState!.reset();
//           });
//           print('Category information saved to Firestore.');
//         }).catchError((error) {
//           print('Error in addSingleCategory callback: $error');
//         });
//       } else {
//         print('Validation failed. Please check the form.');
//       }
//     } catch (e) {
//       print('Error uploading category: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             Row(children: [
//               Container(
//                 alignment: Alignment.topLeft,
//                 padding: const EdgeInsets.all(10),
//                 child: const Text(
//                   'Category',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 36,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(14.0),
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 140,
//                       width: 140,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade300,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.grey.shade800),
//                       ),
//                       child: _image != null
//                           ? Image.memory(
//                               _image,
//                               fit: BoxFit.cover,
//                             )
//                           : Center(
//                               child: Text('Category Image'),
//                             ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         shape: ContinuousRectangleBorder(
//                             borderRadius: BorderRadius.circular(20)),
//                         backgroundColor: Colors.blue.shade700,
//                       ),
//                       onPressed: () {
//                         _pickImage();
//                       },
//                       child: Text(
//                         'Upload Image',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Flexible(
//                 child: SizedBox(
//                   width: 180,
//                   child: TextFormField(
//                     onChanged: (value) {
//                       categoryName = value;
//                     },
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter category Name ';
//                       }
//                       return null;
//                     },
//                     decoration:
//                         InputDecoration(hintText: 'Enter Category Name'),
//                   ),
//                 ),
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   shape: ContinuousRectangleBorder(
//                       borderRadius: BorderRadius.circular(20)),
//                   backgroundColor: Colors.blue.shade400,
//                 ),
//                 onPressed: () {
//                   uploadCategory();
//                 },
//                 child: Text(
//                   'Save',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ]),
//             Divider(
//               color: Colors.grey,
//             ),
//             CategoryWidget(),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   'Categories',
//                   style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             Consumer<AppProvider>(
//               builder: (context, value, child) {
//                 return SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 20),
//                       GridView.builder(
//                         padding: const EdgeInsets.all(12),
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: value.getCategoryList.length,
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 8,
//                         ),
//                         itemBuilder: (context, index) {
//                           CategoryModel categoryModel =
//                               value.getCategoryList[index];
//                           return SingleCategoryItem(
//                             singleCategory: categoryModel,
//                             index: index,
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),

//             // SingleChildScrollView(
//             //     scrollDirection: Axis.vertical, child: CategoryWidget()),
//           ],
//         ),
//       ),
//     );
//   }
// }
















/////////////////////////////////////////

// import 'dart:io';
// import 'dart:typed_data';
// import 'package:admin/constants/constants.dart';
// import 'package:admin/constants/primary_button.dart';
// import 'package:admin/models/catagory_model.dart';
// import 'package:admin/provider/app_provider.dart';
// import 'package:admin/widgets/single_category_item.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// class CategoryViewScreen extends StatefulWidget {
//   static const String id = 'category-view-screen';
//   const CategoryViewScreen({Key? key});

//   @override
//   State<CategoryViewScreen> createState() => _CategoryViewScreenState();
// }

// class _CategoryViewScreenState extends State<CategoryViewScreen> {
//   TextEditingController name = TextEditingController();
//   File? _pickedImage;
//   Uint8List? webImage;

//   Future<void> takePicture() async {
//     if (!kIsWeb) {
//       final ImagePicker _picker = ImagePicker();
//       XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         var selected = File(image.path);
//         setState(() {
//           _pickedImage = selected;
//           webImage = null;
//         });
//       } else {
//         print('No image selected');
//       }
//     } else {
//       FilePickerResult? result =
//           await FilePicker.platform.pickFiles(type: FileType.image);
//       if (result != null) {
//         Uint8List? webFile = result.files.first.bytes;
//         if (webFile != null) {
//           setState(() {
//             webImage = Uint8List.fromList(webFile);
//             _pickedImage = null;
//           });
//         }
//       } else {
//         print('No image selected');
//       }
//     }
//   }

//   showAddCategoryDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Add .....'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _pickedImage == null
//                   ? GestureDetector(
//                       onTap: () {
//                         takePicture();
//                       },
//                       child: Container(
//                         width: 70,
//                         height: 70,
//                         color: Colors.red,
//                         child: webImage != null
//                             ? Image.memory(webImage!)
//                             : const Icon(Icons.camera_alt),
//                       ),
//                     )
//                   : CircleAvatar(
//                       radius: 55,
//                       backgroundImage: FileImage(_pickedImage!),
//                     ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: name,
//                 decoration: const InputDecoration(
//                   fillColor: Colors.white,
//                   filled: true,
//                   hintText: 'Category name',
//                 ),
//               ),
//               const SizedBox(height: 20),
//               PrimaryButton(
//                 onPressed: () async {
//                   if (_pickedImage == null && webImage == null ||
//                       name.text.isEmpty) {
//                     Navigator.of(context).pop();
//                   } else {
//                     AppProvider appProvider =
//                         Provider.of<AppProvider>(context, listen: false);
//                     if (_pickedImage != null) {
//                       appProvider.addCategory(_pickedImage!, name.text);
//                     } else {
//                       appProvider.addCategory(
//                           Uint8List.fromList(webImage!) as File, name.text);
//                     }
//                     showMessage('Category successfully added');
//                     Navigator.of(context).pop();
//                   }
//                 },
//                 title: 'Add',
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Scaffold(
//           backgroundColor: Colors.white.withOpacity(0.9),
//           appBar: AppBar(
//             toolbarHeight: 40,
//             title: const Text('categories'),
//             actions: [
//               IconButton(
//                 onPressed: () {
//                   showAddCategoryDialog(context);
//                 },
//                 icon: const Icon(Icons.add_circle),
//               )
//             ],
//           ),
//           body: Consumer<AppProvider>(
//             builder: (context, value, child) {
//               return SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 20),
//                     GridView.builder(
//                       padding: const EdgeInsets.all(12),
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: value.getCategoryList.length,
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 8,
//                       ),
//                       itemBuilder: (context, index) {
//                         CategoryModel categoryModel =
//                             value.getCategoryList[index];
//                         return SingleCategoryItem(
//                           singleCategory: categoryModel,
//                           index: index,
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//         Positioned(
//           right: 3,
//           bottom: 20,
//           child: FloatingActionButton(
//             backgroundColor: Colors.green,
//             onPressed: () {
//               showAddCategoryDialog(context);
//             },
//             child: const Text(
//               '+',
//               style: TextStyle(fontSize: 40, color: Colors.white),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }





// // // ignore_for_file: prefer_const_constructors

// // import 'dart:io';

// // import 'package:admin/constants/constants.dart';
// // import 'package:admin/constants/primary_button.dart';
// // import 'package:admin/models/catagory_model.dart';
// // import 'package:admin/provider/app_provider.dart';
// // import 'package:admin/widgets/single_category_item.dart';
// // import 'package:file_picker/file_picker.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:provider/provider.dart';

// // class CategoryViewScreen extends StatefulWidget {
// //   static const String id = 'category-view-screen';
// //   const CategoryViewScreen({Key? key});

// //   @override
// //   State<CategoryViewScreen> createState() => _CategoryViewScreenState();
// // }

// // class _CategoryViewScreenState extends State<CategoryViewScreen> {
// //   TextEditingController name = TextEditingController();
// //   File? _pickedImage;
// //   Uint8List webImage = Uint8List(8);

// //   Future<void> takePicture() async {
// //     if (!kIsWeb) {
// //       final ImagePicker _picker = ImagePicker();
// //       XFile? image = await _picker.pickImage(source: ImageSource.gallery);
// //       if (image != null) {
// //         var selected = File(image.path);
// //         setState(() {
// //           _pickedImage = selected;
// //         });
// //       } else {
// //         print('No image selected');
// //       }
// //     } else if (kIsWeb) {
// //       FilePickerResult? result =
// //           await FilePicker.platform.pickFiles(type: FileType.image);
// //       if (result != null) {
// //         Uint8List? webFile = result.files.first.bytes;
// //         if (webFile != null) {
// //           setState(() {
// //             webImage = webFile;
// //             _pickedImage = File('a'); // Adjust this line as needed
// //           });
// //         }
// //       } else {
// //         print('No image selected');
// //       }
// //     } else {
// //       print('Some error occurred');
// //     }
// //   }

// //   showAddCategoryDialog(BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: const Text('Add Category'),
// //           content: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               _pickedImage == null
// //                   ? GestureDetector(
// //                       onTap: () {
// //                         takePicture();
// //                       },
// //                       child: Container(
// //                         width: 70,
// //                         height: 70,
// //                         color: Colors.red,
// //                         child: webImage.isNotEmpty
// //                             ? Image.memory(webImage)
// //                             : Icon(Icons.camera_alt),
// //                       ),
// //                     )
// //                   : CircleAvatar(
// //                       radius: 55,
// //                       backgroundImage: FileImage(_pickedImage!),
// //                     ),
// //               const SizedBox(height: 12),
// //               TextFormField(
// //                 controller: name,
// //                 decoration: const InputDecoration(
// //                   fillColor: Colors.white,
// //                   filled: true,
// //                   hintText: 'Category name',
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //               PrimaryButton(
// //                 onPressed: () async {
// //                   if (_pickedImage == null || name.text.isEmpty) {
// //                     Navigator.of(context).pop();
// //                   } else {
// //                     AppProvider appProvider =
// //                         Provider.of<AppProvider>(context, listen: false);
// //                     appProvider.addCategory(_pickedImage!, name.text);
// //                     showMessage('Category successfully added');
// //                     Navigator.of(context).pop();
// //                   }
// //                 },
// //                 title: 'Add',
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Stack(
// //       children: [
// //         Scaffold(
// //           backgroundColor: Colors.white.withOpacity(0.9),
// //           appBar: AppBar(
// //             toolbarHeight: 40,
// //             title: const Text('categories'),
// //             actions: [
// //               IconButton(
// //                 onPressed: () {
// //                   showAddCategoryDialog(context);
// //                 },
// //                 icon: const Icon(Icons.add_circle),
// //               )
// //             ],
// //           ),
// //           // drawer: CustomDrawer(),
// //           body: Consumer<AppProvider>(
// //             builder: (context, value, child) {
// //               //   AppProvider appProvider = Provider.of<AppProvider>(context);

// //               return SingleChildScrollView(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const SizedBox(height: 20),
// //                     GridView.builder(
// //                       padding: EdgeInsets.all(12),
// //                       shrinkWrap: true,
// //                       physics:
// //                           NeverScrollableScrollPhysics(), // Disable GridView scrolling
// //                       itemCount: value.getCategoryList.length,
// //                       gridDelegate:
// //                           const SliverGridDelegateWithFixedCrossAxisCount(
// //                         crossAxisCount: 8,
// //                       ),
// //                       itemBuilder: (context, index) {
// //                         CategoryModel categoryModel =
// //                             value.getCategoryList[index];
// //                         return SingleCategoryItem(
// //                           singleCategory: categoryModel,
// //                           index: index,
// //                         );
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             },
// //           ),
// //         ),
// //         Positioned(
// //           right: 3,
// //           bottom: 20,
// //           child: FloatingActionButton(
// //             backgroundColor: Colors.green,
// //             onPressed: () {
// //               showAddCategoryDialog(context);
// //             },
// //             child: Text(
// //               '+',
// //               style: TextStyle(fontSize: 40, color: Colors.white),
// //             ),
// //           ),
// //         )
// //       ],
// //     );
// //   }
// // }
