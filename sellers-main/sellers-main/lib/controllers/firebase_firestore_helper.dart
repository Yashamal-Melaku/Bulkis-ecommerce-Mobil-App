// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sellers/constants/constants.dart';
import 'package:sellers/controllers/firebase_storage_helper.dart';
import 'package:sellers/models/catagory_model.dart';
import 'package:sellers/models/order_model.dart';
import 'package:sellers/models/product_model.dart';
import 'package:sellers/models/employee_model.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //----------------------------------------------------------------
  Future<List<CategoryModel>> getCategories() async {
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

//---------------------------------------------------------------
  Stream<List<ProductModel>> getProductsStream() {
    return _firebaseFirestore
        .collectionGroup('products')
        .where('employeeId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      print('Number of Products.....: ${querySnapshot.size}');

      List<ProductModel> productList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();

      print('Product List: $productList');
      return productList;
    });
  }

//-----------------------------------------------------------------
  Future<List<ProductModel>> getProducts() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firebaseFirestore
        .collectionGroup('products')
        .where('employeeId',
            isEqualTo: 'FirebaseAuth.instance.currentUser!.uid')
        .get();

    List<ProductModel> productList =
        querySnapshot.docs.map((e) => ProductModel.fromJson(e.data())).toList();

    return productList;
  }

//----------------------------------------------------------------------
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

//-----------------------------------------------------------------------
  Future<EmployeeModel> getUserInformation() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore
            .collection('employees')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
    return EmployeeModel.fromJson(querySnapshot.data()!);
  }

//----------------------------------------------------------------
  // Future<bool> uploadOrderedProductFirebase(
  //     List<ProductModel> list, BuildContext context, String payment) async {
  //   try {
  //     ShowLoderDialog(context);
  //     double totalPrice = 0.0;
  //     for (var element in list) {
  //       totalPrice += element.price * element.quantity;
  //     }
  //     DocumentReference documentReference = _firebaseFirestore
  //         .collection('userOrders')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .collection('orders')
  //         .doc();
  //     DocumentReference admin =
  //         _firebaseFirestore.collection('orders').doc(documentReference.id);
  //     String uid = FirebaseAuth.instance.currentUser!.uid;
  //     admin.set({
  //       'products': list.map((e) => e.toJson()),
  //       'status': 'pending',
  //       'totalprice': totalPrice,
  //       'payment': payment,
  //       'userid': uid,
  //       'orderId': admin.id,
  //       'employeeId': uid,
  //     });

  //     documentReference.set({
  //       'products': list.map((e) => e.toJson()),
  //       'status': 'pending',
  //       'totalprice': totalPrice,
  //       'payment': payment,
  //       'userId': uid,
  //       'orderId': documentReference.id,
  //       'employeeId': uid,
  //     });
  //     showMessage('Ordered Successfully');
  //     Navigator.of(context, rootNavigator: true).pop();

  //     return true;
  //   } catch (e) {
  //     showMessage(e.toString());

  //     Navigator.of(context, rootNavigator: true).pop();

  //     return false;
  //   }
  // }

//----------------------------------------------------------------
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

//----------------------------------------------------------------
  void updateTokenFromFirebase() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _firebaseFirestore
          .collection('employees')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'notificationToken': token});
    }
  }

//----------------------------------------------------------------
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

//----------------------------------------------------------------
  Future<List<EmployeeModel>> getUserList() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firebaseFirestore
        .collection('employees')
        .where('employeeId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    return querySnapshot.docs
        .map((e) => EmployeeModel.fromJson(e.data()))
        .toList();
  }

//----------------------------------------------------------------
  // Future<List<CategoryModel>> getcategories() async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //         await _firebaseFirestore.collection('categories').get();
  //     List<CategoryModel> categoriesList = querySnapshot.docs
  //         .map((e) => CategoryModel.fromJson(e.data()))
  //         .toList();
  //     return categoriesList;
  //   } catch (e) {
  //     showMessage(e.toString());
  //     return [];
  //   }
  // }

//----------------------------------------------------------------
  Future<String> deleteSingleUser(String id) async {
    try {
      _firebaseFirestore.collection('employees').doc(id).delete();
      return 'Successfully deleted';
    } catch (e) {
      return e.toString();
    }
  }

// ----------------------------------------------------------------

  Future<void> updateUser(EmployeeModel employeeModel) async {
    try {
      await _firebaseFirestore
          .collection('employees')
          .doc(employeeModel.employeeId)
          .update(employeeModel.toJson());
    } catch (e) {}
  }

//----------------------------------------------------------------
  Future<String> deleteSingleCategory(String id) async {
    try {
      await _firebaseFirestore.collection('categories').doc(id).delete();

      //  await Future.delayed(const Duration(seconds: 3), () {});
      return 'Successfully deleted';
    } catch (e) {
      return e.toString();
    }
  }

//----------------------------------------------------------------
  Future<void> updateSingleCategory(CategoryModel categoryModel) async {
    try {
      await _firebaseFirestore
          .collection('categories')
          .doc(categoryModel.id)
          .update(categoryModel.toJson());
    } catch (e) {}
  }

//----------------------------------------------------------------
  Future<CategoryModel> addSingleCategory(File image, String name) async {
    DocumentReference<Map<String, dynamic>> reference =
        _firebaseFirestore.collection('categories').doc();
    String imageUrl = await FirebaseStorageHelper.instance
        .uploadProductImage(reference.id, image);
    CategoryModel addCategory =
        CategoryModel(image: imageUrl, id: reference.id, name: name);
    await reference.set(addCategory.toJson());
    return addCategory;
  }

//----------------------------------------------------------------
  Future<String> deleteProduct(String id) async {
    try {
      await _firebaseFirestore.collection('products').doc(id).delete();

      await Future.delayed(const Duration(seconds: 1), () {});
      return 'Successfully deleted';
    } catch (e) {
      return e.toString();
    }
  }

//----------------------------------------------------------------
  Future<void> updateproduct(ProductModel productModel) async {
    try {
      DocumentReference productRef =
          _firebaseFirestore.collection('products').doc(productModel.id);
      DocumentSnapshot productSnapshot = await productRef.get();
      if (productSnapshot.exists) {
        await productRef.update(productModel.toJson());
        showMessage('Udated successfully');
      }
    } catch (e) {
      print(e.toString());
    }
  }

//----------------------------------------------------------------
  Future<ProductModel> addProduct(
    File image,
    String name,
    String categoryId,
    String description,
    String price,
    String discount,
    String quantity,
    String size,
    String measurement,
    String startDate,
    String endDate,
  ) async {
    DocumentReference<Map<String, dynamic>> reference =
        _firebaseFirestore.collection('products').doc();
    String employeeId = FirebaseAuth.instance.currentUser!.uid;
    String imageUrl = await FirebaseStorageHelper.instance
        .uploadproductImage(reference.id, image);
    ProductModel addProduct = ProductModel(
      image: imageUrl,
      id: reference.id,
      name: name,
      description: description,
      categoryId: categoryId,
      price: double.parse(price),
      discount: double.parse(discount),
      quantity: int.parse(quantity),
      size: double.parse(size),
      measurement: measurement,
      status: 'pending',
      isFavorite: false,
      disabled: false,
      productId: reference.id,
      employeeId: employeeId,
      startDate: DateTime.now(),
      endDate: DateTime.parse(endDate),
    );
    await reference.set(addProduct.toJson());
    return addProduct;
  }

////----------------------------------------------------------------------

  Stream<EmployeeModel> getEmployeeInfo({bool? approved, String? role}) {
    Query query = FirebaseFirestore.instance.collection('employees');
    query =
        query.where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid);

    return query.snapshots().map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        EmployeeModel employeeModel =
            EmployeeModel.fromJson(doc.data() as Map<String, dynamic>);
        return employeeModel;
      } else {
        return EmployeeModel(approved: approved!, role: role!);
      }
    });
  }

//-----------------------------------------------------------------------
  Stream<List<OrderModel>> getOrderListStream({String? status}) {
    CollectionReference<Map<String, dynamic>> ordersCollection =
        _firebaseFirestore.collection('orders')
          ..where('employeeId',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid);
    Query<Map<String, dynamic>> query = status != null
        ? ordersCollection.where('status', isEqualTo: status)
        : ordersCollection;

    return query.snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> ordersSnapshot) => ordersSnapshot
              .docs
              .map((e) => OrderModel.fromJson(e.data()))
              .toList(),
        );
  }
  //----------------------------------------------------------------

  Stream<int> getOrderCountByStatus(String status) {
    return _firebaseFirestore
        .collection('orders')
        .where('status', isEqualTo: status)
        .snapshots()
        .map((querySnapshot) => querySnapshot.size);
  }

  //----------------------------------------------------------------
  Future<List<OrderModel>> getCompletedOrderList() async {
    QuerySnapshot<Map<String, dynamic>> completedOrders =
        await _firebaseFirestore
            .collection('orders')
            .where('employeeId',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('status', isEqualTo: 'completed')
            .get();

    List<OrderModel> completedOrderList =
        completedOrders.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return completedOrderList;
  }

//----------------------------------------------------------------
  Future<void> updateDeliveryOrder(OrderModel orderModel, String status) async {
    String deliveryId = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot<Map<String, dynamic>> sellerSnapshot =
          await _firebaseFirestore
              .collection('employees')
              .doc(deliveryId)
              .get();

      if (sellerSnapshot.exists) {
        String deliveryName = sellerSnapshot['firstName'];
        String deliveryPhone = sellerSnapshot['phoneNumber'];

        String userIdFromDatabase = orderModel.userId;
        await _firebaseFirestore
            .collection('userOrders')
            .doc(userIdFromDatabase)
            .collection('orders')
            .doc(orderModel.orderId)
            .update({
          'status': status,
          'deliveryId': deliveryId,
          'deliveryName': deliveryName,
          'deliveryPhone': deliveryPhone,
        });

        await _firebaseFirestore
            .collection('orders')
            .doc(orderModel.orderId)
            .update({
          'status': status,
          'deliveryId': deliveryId,
          'deliveryName': deliveryName,
          'deliveryPhone': deliveryPhone,
        });
      } else {
        print('Seller document does not exist.');
      }
    } catch (e) {
      print('Error updating order: $e');
      print(orderModel.orderId);
    }
  }
//----------------------------------------------------------------
}
