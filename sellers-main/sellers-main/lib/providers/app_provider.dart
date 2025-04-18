// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellers/constants/constants.dart';
import 'package:sellers/controllers/firebase_firestore_helper.dart';
import 'package:sellers/controllers/firebase_storage_helper.dart';
import 'package:sellers/models/catagory_model.dart';
import 'package:sellers/models/order_model.dart';
import 'package:sellers/models/product_model.dart';
import 'package:sellers/models/employee_model.dart';

class AppProvider with ChangeNotifier {
  //////// cart list
  final List<ProductModel> _cartProductList = [];
  final List<ProductModel> _buyProductList = [];

  // EmployeeModel _EmployeeModel = EmployeeModel(
  //   id: '',
  //   idCard: '',
  //   firstName: '',
  //   middleName: '',
  //   lastName: '',
  //   phoneNumber: '',
  //   email: '',
  //   country: '',
  //   region: '',
  //   city: '',
  //   zone: '',
  //   woreda: '',
  //   kebele: '',
  //   approved: false,
  //   role: '',
  // );

  // EmployeeModel get getUserInformation => _EmployeeModel;

  void addToCartproduct(ProductModel productModel) {
    _cartProductList.add(productModel);
    notifyListeners();
  }

  void removeCartproduct(ProductModel productModel) {
    _cartProductList.remove(productModel);
    notifyListeners();
  }

  List<ProductModel> get getCartProductList => _cartProductList;

  //// Favorite /////
  ///
  ///
  final List<ProductModel> _favoriteProductList = [];

  void addToFavoriteproduct(ProductModel productModel) {
    _favoriteProductList
        .add(productModel); //_cartProductList.add(productModel);
    notifyListeners();
  }

  void removeFavoriteproduct(ProductModel productModel) {
    _favoriteProductList
        .remove(productModel); //_cartProductList.remove(productModel);
    notifyListeners();
  }

  List<ProductModel> get getFavoriteProductList => _favoriteProductList;

  //////////// user informaation
  ///

  // void getUserInfoFirebase() async {
  //   _EmployeeModel =
  //       await FirebaseFirestoreHelper.instance.getUserInformation();
  //   notifyListeners();
  // }

  // void updateUserInfoFirebase(
  //     BuildContext context, EmployeeModel EmployeeModel, file) async {
  //   if (file == null) {
  //     ShowLoderDialog(context);
  //     _EmployeeModel = EmployeeModel;
  //     FirebaseFirestore.instance
  //         .collection('sellers')
  //         .doc(_EmployeeModel.id)
  //         .set(_EmployeeModel.toJson());
  //     Navigator.of(context, rootNavigator: true).pop();
  //     Navigator.of(context).pop();
  //   } else {
  //     ShowLoderDialog(context);

  // String imageUrl =
  //     await FirebaseStorageHelper.instance.uploadSellerImage(_EmployeeModel.id!,image!);
  // _EmployeeModel = EmployeeModel.copyWith(
  //   image: imageUrl,
  // );
  //     await FirebaseFirestore.instance
  //         .collection('sellers')
  //         .doc(_EmployeeModel.id)
  //         .set(_EmployeeModel.toJson());

  //     Navigator.of(context, rootNavigator: true).pop();
  //     Navigator.of(context).pop();
  //   }
  //   showMessage('succesfully updated');
  //   notifyListeners();
  // }

  /////       Total price  ///////////

  double totalPrice() {
    double totalPrice = 0.0;
    for (var element in _cartProductList) {
      totalPrice += element.price * element.quantity;
    }

    return totalPrice;
  }

  double totalPriceBuyProductList() {
    double totalPrice = 0.0;
    for (var element in _buyProductList) {
      totalPrice += element.price * element.quantity;
    }

    return totalPrice;
  }

  void updateQuantity(ProductModel productModel, int quantity) {
    int index = _cartProductList.indexOf(productModel);
    _cartProductList[index].quantity = quantity;
    notifyListeners();
  }

  ///////////////////  Buy product ///////////////////////
  ///

  void addBuyProduct(ProductModel model) {
    _buyProductList.add(model);
    notifyListeners();
  }

  void addBuyProductCartList() {
    _buyProductList.addAll(_cartProductList);
    notifyListeners();
  }

  void clearBuyProduct() {
    _buyProductList.clear();
    notifyListeners();
  }

  void clearCart() {
    _cartProductList.clear();
    notifyListeners();
  }

  List<ProductModel> get getBuyproductList => _buyProductList;

  List<EmployeeModel> _userList = [];
  List<CategoryModel> _categoryList = [];
  List<ProductModel> _productlist = [];
  List<OrderModel> _completedOrders = [];
  List<OrderModel> _pendingOrders = [];
  List<OrderModel> _canceledOrders = [];
  List<OrderModel> _deliveryOrders = [];
  List<OrderModel> _allOrders = [];

  double _totalEarning = 0.0;

  // Future<void> getUserListFunction() async {
  //   _categoryList = await FirebaseFirestoreHelper.instance.getcategories();
  //   notifyListeners();
  // }

  Future<void> getCategoryListFunction() async {
    _userList = await FirebaseFirestoreHelper.instance.getUserList();
    notifyListeners();
  }

  // Future<void> getAllOrdersFunction() async {
  //   _allOrders = await FirebaseFirestoreHelper.instance.getAllOrderList();
  //   notifyListeners();
  // }

  Future<void> getCompletedOrderList() async {
    _completedOrders =
        await FirebaseFirestoreHelper.instance.getCompletedOrderList();
    for (var element in _completedOrders) {
      _totalEarning += element.totalprice;
    }
    notifyListeners();
  }

  // Future<void> getPendingOrders() async {
  //   _pendingOrders = await FirebaseFirestoreHelper.instance.getPendingOrders();
  //   notifyListeners();
  // }

  // Future<void> getCanceledOrders() async {
  //   _canceledOrders = await FirebaseFirestoreHelper.instance.getCancelOrders();
  //   notifyListeners();
  // }

  // Future<void> getDeliveryOrders() async {
  //   _deliveryOrders =
  //       await FirebaseFirestoreHelper.instance.getDeliveryOrders();
  //   notifyListeners();
  // }

  Future<void> deleteUserFromFirebase(EmployeeModel EmployeeModel) async {
    notifyListeners();
    String value = await FirebaseFirestoreHelper.instance
        .deleteSingleUser(EmployeeModel.employeeId!);

    if (value == 'Successfully deleted') {
      _userList.remove(EmployeeModel);
      showMessage('User deleted successfully');
    }
    notifyListeners();
  }

  List<EmployeeModel> get getUserList => _userList;
  double get getTotalEarnings => _totalEarning;
  List<CategoryModel> get getCategoryList => _categoryList;
  // List<ProductModel> get getProducts => _productlist;
  List<OrderModel> get getCompletedOrder => _completedOrders;
  // List<OrderModel> get getPendingOrderList => _pendingOrders;
  // List<OrderModel> get getCanceledOrderList => _canceledOrders;
  // List<OrderModel> get getDeliveryOrderList => _deliveryOrders;
  // List<OrderModel> get getAllOrderList => _allOrders;

  Future<void> callBackFunction() async {
    //await getUserListFunction();
    await getCategoryListFunction();
    // await getProduct();
    await getCompletedOrderList();
    // await getPendingOrders();
    // await getCanceledOrders();
    // await getDeliveryOrders();
    // await getAllOrdersFunction();
  }

  void updateUserList(int index, EmployeeModel userModel) async {
    await FirebaseFirestoreHelper.instance.updateUser(userModel);

    // int index=_userList.indexOf(userModel);
    _userList[index] = userModel;
    notifyListeners();
  }

/////////     category

  Future<void> deleteCategoryFromFirebase(CategoryModel categoryModel) async {
    notifyListeners();
    String value = await FirebaseFirestoreHelper.instance
        .deleteSingleCategory(categoryModel.id);

    if (value == 'Successfully deleted') {
      _categoryList.remove(categoryModel);
      showMessage('Category deleted successfully');
    }
    notifyListeners();
  }

  void updateCategoryList(int index, CategoryModel categoryModel) async {
    await FirebaseFirestoreHelper.instance.updateSingleCategory(categoryModel);

    _categoryList[index] = categoryModel;
    notifyListeners();
  }

  void addCategory(File image, String name) async {
    CategoryModel categoryModel =
        await FirebaseFirestoreHelper.instance.addSingleCategory(image, name);

    _categoryList.add(categoryModel);
    notifyListeners();
  }

  Future<void> getProduct() async {
    _productlist = await FirebaseFirestoreHelper.instance.getProducts();
    notifyListeners();
  }

  // Future<void> deleteProductFromFirebase(ProductModel productModel) async {
  //   notifyListeners();
  //   String value = await FirebaseFirestoreHelper.instance
  //       .deleteProduct(productModel.id);

  //   if (value == 'Successfully deleted') {
  //     _productlist.remove(productModel);
  //     showMessage('Product deleted successfully');
  //   }
  //   notifyListeners();
  // }

  Future<void> updateProductList(int index, ProductModel productModel) async {
    await FirebaseFirestoreHelper.instance.updateproduct(productModel);
    _productlist[index] = productModel;
    notifyListeners();
  }

  void addProduct(
    File image,
    String name,
    String description,
    String categoryId,
    String price,
    String discount,
    String quantity,
    String size,
    String measurement,
    String startDate,
    String endDate,
  ) async {
    ProductModel productModel = await FirebaseFirestoreHelper.instance
        .addProduct(image, name, categoryId, description, price, discount,
            quantity, size, measurement, startDate, endDate);

    _productlist.add(productModel);
    notifyListeners();
  }

  /////////// pending  Orders          ///////
  ///
  ///
  ///

  void updatePendingOrder(OrderModel order) {
    _deliveryOrders.add(order);
    _pendingOrders.remove(order);
    notifyListeners();
    showMessage('order sent to Delivery');
  }

  void updateCancelPendingOrder(OrderModel order) {
    _canceledOrders.add(order);
    _pendingOrders.remove(order);
    notifyListeners();
    showMessage('Order canceled from pending');
  }

  void updateCanceleDeliveryOrder(OrderModel order) {
    _canceledOrders.add(order);
    _deliveryOrders.remove(order);
    notifyListeners();
    showMessage('Order canceled from delivery');
  }

//   Stream<List<String>> getCategoriesStream() {
//   Stream<QuerySnapshot> _categoriesStream =
//       FirebaseFirestore.instance.collection('categories').snapshots();

//   return _categoriesStream.map((snapshot) {
//     return snapshot.docs.map((doc) {
//       return doc.get('name') as String; // Assuming 'name' is the field containing category names
//     }).toList();
//   });
// }
}
