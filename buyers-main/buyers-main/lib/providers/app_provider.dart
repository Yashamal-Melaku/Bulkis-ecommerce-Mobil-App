// ignore_for_file: use_build_context_synchronously

import 'package:buyers/constants/constants.dart';
import 'package:buyers/controllers/firebase_firestore_helper.dart';
import 'package:buyers/controllers/firebase_storage_helper.dart';
import 'package:buyers/models/product_model.dart';
import 'package:buyers/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  //////// cart list
  final List<ProductModel> _cartProductList = [];
  final List<ProductModel> _buyProductList = [];
  UserModel? _userModel;

  UserModel get getUserInformation => _userModel!;

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

  void getUserInfoFirebase() async {
    _userModel = await FirebaseFirestoreHelper.instance.getUserInformation();
    notifyListeners();
  }

  void updateUserInfoFirebase(
      BuildContext context, UserModel userModel, file) async {
    if (file == null) {
      ShowLoderDialog(context);
      _userModel = userModel;
      FirebaseFirestore.instance
          .collection('users')
          .doc(_userModel!.id)
          .set(_userModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    } else {
      ShowLoderDialog(context);
      String imageUrl =
          await FirebaseStorageHelper.instance.uploadUserImage(file);
      _userModel = userModel.copyWith(image: imageUrl);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userModel!.id)
          .set(_userModel!.toJson());

      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    }
    showMessage('succesfully updated');
    notifyListeners();
  }

  /////       Total price  ///////////

  double totalPrice() {
    double totalPrice = 0.0;
    for (var element in _cartProductList) {
      if (element.discount == 0.0) {
        totalPrice += element.price * element.quantity;
      } else {
        totalPrice += element.discount * element.quantity;
      }
    }

    return totalPrice;
  }

  double totalPriceBuyProductList() {
    double totalPrice = 0.0;
    for (var element in _buyProductList) {
      if (element.discount == 0.0) {
        totalPrice += element.price * element.quantity;
      } else {
        totalPrice += element.discount * element.quantity;
      }
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
}
