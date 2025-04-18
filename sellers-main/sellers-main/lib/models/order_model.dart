import 'package:sellers/models/product_model.dart';

class OrderModel {
  String payment;
  String status;
  List<ProductModel> products;
  double totalprice;
  String orderId;
  String userId;
  String? address;
  double? latitude;
  double? longitude;
  DateTime? orderDate;
  String? deliveryId;
  String? deliveryName;
  String? deliveryPhone;

  OrderModel({
    required this.totalprice,
    required this.orderId,
    required this.payment,
    required this.products,
    required this.status,
    required this.userId,
    this.address,
    this.latitude,
    this.longitude,
    this.orderDate,
    this.deliveryId,
    this.deliveryName,
    this.deliveryPhone,
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
      address: json['address'] ?? "",
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      orderDate:
          json['orderDate'] != null ? DateTime.parse(json['orderDate']) : null,
      deliveryId: json['deliveryId'] ?? "",
      deliveryName: json['deliveryName'] ?? "",
      deliveryPhone: json['deliveryPhone'] ?? "",
    );
  }
}
