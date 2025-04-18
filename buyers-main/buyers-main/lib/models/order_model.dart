import 'package:buyers/models/product_model.dart';

class OrderModel {
  String payment;
  String status;
  List<ProductModel> products;
  double totalprice;
  String orderId;
  String userId;
  String sellerId;
  String address;

  OrderModel({
    required this.totalprice,
    required this.orderId,
    required this.payment,
    required this.products,
    required this.status,
    required this.userId,
    required this.sellerId,
    required this.address,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<dynamic>? productMap = json['products'];
    return OrderModel(
      orderId: json['orderId'] ?? "",
      products:
          (productMap ?? []).map((e) => ProductModel.fromJson(e)).toList(),
      totalprice: (json['totalprice'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? "",
      payment: json['payment'] ?? "",
      userId: json['userId'] ?? "",
      sellerId: json['sellerId'] ?? "",
      address: json['address'] ?? "",
    );
  }
}
