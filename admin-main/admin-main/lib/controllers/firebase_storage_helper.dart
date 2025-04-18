import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  static FirebaseStorageHelper instance = FirebaseStorageHelper();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadUserImage(String userId, File image) async {
    TaskSnapshot taskSnapshot = await _storage.ref(userId).putFile(image);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<String> uploadCategoryImage(
      String categoryId, Uint8List imageBytes) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
     // print('fileName : $fileName');
      TaskSnapshot taskSnapshot =
          await _storage.ref('$categoryId/$fileName').putData(imageBytes);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
     // print('imageUrl: $imageUrl');
      return imageUrl;
    } catch (e) {
    //  print('Error in uploadCategoryImage: $e');
      rethrow;
    }
  }

  uploadCategoryImageToStorage(dynamic image, Uint8List uint8list) async {
    Uint8List bytes;
    String imageName;

    if (image is Uint8List) {
      bytes = image;
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      imageName = fileName;
    } else if (image is File) {
      bytes = await image.readAsBytes();
      imageName = image.path.split('/').last;
    } else {
      throw Exception('Unsupported image type');
    }

    Reference ref = _storage.ref().child('CategoryImages').child(imageName);
    UploadTask uploadTask = ref.putData(bytes);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadProductImage(String categoryId, File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    TaskSnapshot taskSnapshot =
        await _storage.ref('$categoryId/productId/$fileName').putFile(image);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<String> uploadSellerImage(String userId, File image) async {
    TaskSnapshot taskSnapshot = await _storage.ref(userId).putFile(image);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }
}
