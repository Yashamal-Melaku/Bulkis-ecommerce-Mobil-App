// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:admin/constants/constants.dart';
import 'package:admin/controllers/firebase_storage_helper.dart';
import 'package:admin/models/catagory_model.dart';
import 'package:admin/models/order_model.dart';
import 'package:admin/models/product_model.dart';
import 'package:admin/models/seller_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
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

  // Future<List<ProductModel>> getBestProducts() async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //         await _firebaseFirestore.collectionGroup('products').get();
  //     List<ProductModel> productModelList = querySnapshot.docs
  //         .map((e) => ProductModel.fromJson(e.data()))
  //         .toList();
  //     return productModelList; // Return the mapped productModelList
  //   } catch (e) {
  //     showMessage(e.toString());
  //     return [];
  //   }
  // }

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
      return productModelList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<SellerModel> getUserInformation() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore
            .collection('sellers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
    return SellerModel.fromJson(querySnapshot.data()!);
  }

  Future<bool> uploadOrderedProductFirebase(
      List<ProductModel> list, BuildContext context, String payment) async {
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
      String uid = FirebaseAuth.instance.currentUser!.uid;
      admin.set({
        'products': list.map((e) => e.toJson()),
        'status': 'pending',
        'totalprice': totalPrice,
        'payment': payment,
        'userid': uid,
        'orderId': admin.id,
        'sellerId': uid,
      });

      documentReference.set({
        'products': list.map((e) => e.toJson()),
        'status': 'pending',
        'totalprice': totalPrice,
        'payment': payment,
        'userId': uid,
        'orderId': documentReference.id,
        'sellerId': uid,
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

      return [];
    }
  }

  // void updateTokenFromFirebase() async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   if (token != null) {
  //     await _firebaseFirestore
  //         .collection('sellers')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .update({'notificationToken': token});
  //   }
  // }

  Future<void> updateOrder(OrderModel orderModel, String status) async {
    try {
      DocumentSnapshot orderSnapshot = await _firebaseFirestore
          .collection('orders')
          .doc(orderModel.orderId)
          .get();

      if (orderSnapshot.exists) {
        String userIdFromDatabase = orderSnapshot['userId'];

        await _firebaseFirestore
            .collection('userOrders')
            .doc(userIdFromDatabase)
            .collection('orders')
            .doc(orderModel.orderId)
            .update({'status': status});

        await _firebaseFirestore
            .collection('orders')
            .doc(orderModel.orderId)
            .update({'status': status});
      } else {
        print('Document does not exist.');
      }
    } catch (e) {
      print('Error updating order: $e');
      print(orderModel.orderId);
    }
  }

  Future<List<SellerModel>> getUserList() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore.collection('sellers').get();
    return querySnapshot.docs
        .map((e) => SellerModel.fromJson(e.data()))
        .toList();
  }

  Future<List<CategoryModel>> getcategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection('categories').get();
      List<CategoryModel> categoriesList = querySnapshot.docs
          .map((e) => CategoryModel.fromJson(e.data()))
          .toList();
      return categoriesList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<String> deleteSingleUser(String id) async {
    try {
      _firebaseFirestore.collection('users').doc(id).delete();
      return 'Successfully deleted';
    } catch (e) {
      return e.toString();
    }
  }

////// £££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
  ///
  ///

  Future<void> updateUser(SellerModel userModel) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(userModel.id)
          .update(userModel.toJson());
    } catch (e) {}
  }

  Future<String> deleteSingleCategory(String id) async {
    try {
      await _firebaseFirestore.collection('categories').doc(id).delete();

      //  await Future.delayed(const Duration(seconds: 3), () {});
      return 'Successfully deleted';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> updateSingleCategory(CategoryModel categoryModel) async {
    try {
      await _firebaseFirestore
          .collection('categories')
          .doc(categoryModel.id)
          .update(categoryModel.toJson());
    } catch (e) {}
  }

  Future<CategoryModel> addSingleCategory(
      Uint8List imageBytes, String name) async {
    try {
      DocumentReference<Map<String, dynamic>> reference =
          _firebaseFirestore.collection('categories').doc();
      // print('Document Reference ID: ${reference.id}');

      String imageUrl = await FirebaseStorageHelper.instance
              .uploadCategoryImage(reference.id, Uint8List.fromList(imageBytes))
          as String;

      // print('Image uploaded to Storage. URL: $imageUrl');

      CategoryModel addCategory =
          CategoryModel(image: imageUrl, id: reference.id, name: name);
      await reference.set(addCategory.toJson());
      print('Category information saved to Firestore.');

      return addCategory;
    } catch (e) {
      print('Error in addSingleCategory: $e');
      rethrow;
    }
  }

  ///////// products /////////////
  ///
  Future<List<ProductModel>> getProducts() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore.collectionGroup('products').get();
    List<ProductModel> productList =
        querySnapshot.docs.map((e) => ProductModel.fromJson(e.data())).toList();
    return productList;
  }

  Future<String> deleteProduct(String categoryId, String productId) async {
    try {
      await _firebaseFirestore
          .collection('categories')
          .doc(categoryId)
          .collection('products')
          .doc(productId)
          .delete();

      await Future.delayed(const Duration(seconds: 1), () {});
      return 'Successfully deleted';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> updateSingleProduct(ProductModel productModel) async {
    try {
      DocumentReference productRef = _firebaseFirestore
          .collection('categories')
          .doc(productModel.categoryId)
          .collection('products')
          .doc(productModel.id);

      DocumentSnapshot productSnapshot = await productRef.get();

      if (productSnapshot.exists) {
        await productRef.update(productModel.toJson());
        showMessage('Udated successfully');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ProductModel> addSingleProduct(
    File image,
    String name,
    String categoryId,
    String description,
    String price,
    String discount,
    String quantity,
    String size,
    String measurement,
  ) async {
    DocumentReference<Map<String, dynamic>> reference = _firebaseFirestore
        .collection('categories')
        .doc(categoryId)
        .collection('products')
        .doc();

    ///////////////////////////

    DocumentReference admin =
        _firebaseFirestore.collection('adminProducts').doc(reference.id);
    String sellerId = FirebaseAuth.instance.currentUser!.uid;

    admin.set({
      'productId': admin.id,
      'sellerId': sellerId,
      'name': name,
      'categoryId': categoryId,
    });
    String imageUrl = await FirebaseStorageHelper.instance
        .uploadSellerImage(reference.id, image);
    ProductModel addProduct = ProductModel(
      image: imageUrl,
      id: reference.id,
      name: name,
      description: description,
      categoryId: categoryId,
      price: double.parse(price),
      discount: double.parse(discount),
      quantity: int.parse(quantity),
      //size: double.parse(size),
      //measurement: measurement,
      status: 'pending',
      isFavorite: false,
      // disabled: false,
      //productId: reference.id,
      // sellerId: sellerId,
    );
    await reference.set(addProduct.toJson());
    return addProduct;
  }

//////                Get orders  ///////////////
  ///
// ///
  Stream<List<OrderModel>> getOrderListStream({String? status}) {
    CollectionReference<Map<String, dynamic>> ordersCollection =
        _firebaseFirestore.collection('orders');
    Query<Map<String, dynamic>> query = status != null
        ? ordersCollection.where('status', isEqualTo: status)
        : ordersCollection;

    return query.snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> ordersSnapshot) => ordersSnapshot
              .docs
              .map((e) => OrderModel.fromJson(e.data()!))
              .toList(),
        );
  }

/////////////////  end   ///////////////////  ////end///////

  Future<List<OrderModel>> getCompletedOrderList() async {
    QuerySnapshot<Map<String, dynamic>> completedOrders =
        await _firebaseFirestore
            .collection('orders')
            .where('status', isEqualTo: 'completed')
            .get();

    List<OrderModel> completedOrderList =
        completedOrders.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return completedOrderList;
  }

  Future<List<OrderModel>> getPendingOrders() async {
    QuerySnapshot<Map<String, dynamic>> pendingOrders = await _firebaseFirestore
        .collection('orders')
        .where('status', isEqualTo: 'pending')
        .get();

    List<OrderModel> pendingOrderList =
        pendingOrders.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return pendingOrderList;
  }

  Future<List<OrderModel>> getDeliveryOrders() async {
    QuerySnapshot<Map<String, dynamic>> pendingOrders = await _firebaseFirestore
        .collection('orders')
        .where('status', isEqualTo: 'delivery')
        .get();

    List<OrderModel> getDeliveryOrders =
        pendingOrders.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return getDeliveryOrders;
  }

  Future<void> updateSeller(SellerModel seller) async {
    try {
      DocumentReference<Map<String, dynamic>> sellerRef =
          _firebaseFirestore.collection('sellers').doc(seller.id);
      await sellerRef.update({'approved': seller.approved});
    } catch (e) {
      print('Error updating seller: $e');
    }
  }

  /////                      seller
  ///
  ///
  ///

  Stream<List<SellerModel>> getSellersStream({bool? approved, String? role}) {
    Query query = FirebaseFirestore.instance.collection('sellers');
    if (approved != null) {
      query = query.where('approved', isEqualTo: approved);
    }

    if (role != null) {
      query = query.where('role', isEqualTo: role);
    }
    return query.snapshots().map((querySnapshot) {
      List<SellerModel> sellerModels = querySnapshot.docs
          .map(
              (doc) => SellerModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return sellerModels;
    });
  }
}
