// ignore_for_file: use_build_context_synchronously

import 'package:buyers/constants/constants.dart';
import 'package:buyers/models/catagory_model.dart';
import 'package:buyers/models/order_model.dart';
import 'package:buyers/models/product_model.dart';
import 'package:buyers/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final store = GetStorage();

  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection('categories').get();
      List<CategoryModel> categoriesList = querySnapshot.docs
          .map((e) => CategoryModel.fromJson(e.data()))
          .toList();
      return categoriesList; // Return the mapped categoriesList
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getBestProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collectionGroup('products').get();
      List<ProductModel> productModelList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();
      return productModelList; // Return the mapped productModelList
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getCategoryViewProduct(String id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection('categories')
              .doc(id)
              .collection('products')
              .get();
      List<ProductModel> productModelList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();
      return productModelList; // Return the mapped productModelList
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<UserModel> getUserInformation() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
    return UserModel.fromJson(querySnapshot.data()!);
  }

  Future<bool> uploadOrderedProductFirebase(
      List<ProductModel> list, BuildContext context, String payment) async {
    String address = store.read('address');
    try {
      ShowLoderDialog(context);
      double totalPrice = 0.0;
      for (var element in list) {
        totalPrice += element.price * element.quantity;
      }
      DocumentReference documentReference = _firebaseFirestore
          .collection('userOrders')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orders')
          .doc();

      DocumentReference admin =
          _firebaseFirestore.collection('orders').doc(documentReference.id);

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collectionGroup('products').get();
      String productId = querySnapshot.docs.first.id;

      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
          .collection('adminProducts')
          .doc(productId)
          .get();
      String sellerId = snapshot['sellerId'];
      String uid = FirebaseAuth.instance.currentUser!.uid;
      admin.set({
        'products': list.map((e) => e.toJson()),
        'status': 'pending',
        'totalprice': totalPrice,
        'payment': payment,
        'userId': uid,
        'orderId': admin.id,
        'sellerId': sellerId,
        'address': address,
      });

      documentReference.set({
        'products': list.map((e) => e.toJson()),
        'status': 'pending',
        'totalprice': totalPrice,
        'payment': payment,
        'userId': uid,
        'orderId': documentReference.id,
        'sellerId': sellerId,
        'address': address,
      });
      showMessage('Ordered Successfully');
      Navigator.of(context, rootNavigator: true).pop();

      return true;
    } catch (e) {
      showMessage(e.toString());
      Navigator.of(context, rootNavigator: true).pop();
      return false;
    }
  }

  ///////// get order user //////

  Future<List<OrderModel>> getUserOrder() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection('userOrders')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('orders')
              .get();

      List<OrderModel> orderList = querySnapshot.docs
          .map((element) => OrderModel.fromJson(element.data()))
          .toList();

      return orderList;
    } catch (error) {
      showMessage(error.toString());
      print(error.toString());

      return [];
    }
  }

  void updateTokenFromFirebase() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _firebaseFirestore
          .collection('sellers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      // .update({'notificationToken': token});
    }
  }

  Future<void> updateOrder(OrderModel orderModel, String status) async {
    await _firebaseFirestore
        .collection('userOrders')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('orders')
        .doc(orderModel.orderId)
        .update({'status': status});

    await _firebaseFirestore
        .collection('orders')
        .doc(orderModel.orderId)
        .update({'status': status});
  }

  Future<String> generateQRCode(String orderId) async {
    String qrCodeData = orderId;

    return qrCodeData;
  }
}
