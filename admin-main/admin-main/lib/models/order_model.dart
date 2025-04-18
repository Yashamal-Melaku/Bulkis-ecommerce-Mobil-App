

import 'package:admin/models/product_model.dart';

class OrderModel {
  String payment;
  String status;
  List<ProductModel> products;
  double totalprice;
  String orderId;
  String userId;

  OrderModel({
    required this.totalprice,
    required this.orderId,
    required this.payment,
    required this.products,
    required this.status,
    required this.userId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<dynamic>? productMap = json['products'] as List<dynamic>?;

    return OrderModel(
      orderId: json['orderId'] ?? '',
      products: productMap?.map((e) => ProductModel.fromJson(e)).toList() ?? [],
      totalprice: (json['totalprice'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      payment: json['payment'] ?? '',
      userId: json['userId'] ?? '',
    );
  }
}
