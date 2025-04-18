import 'dart:convert';

class ProductModel {
  String categoryId;
  String description;
  String id;
  String image;
  String name;
  double price;
  double discount;
  String status;
  bool isFavorite;
  int quantity;

  ProductModel({
    required this.categoryId,
    required this.description,
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.discount,
    required this.status,
    required this.isFavorite,
    required this.quantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      categoryId: json['categoryId'] ?? '',
      description: json['description'] ?? '',
      id: json['id'] ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      isFavorite: false,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'description': description,
      'id': id,
      'image': image,
      'name': name,
      'price': price,
      'discount': discount,
      'status': status,
      'isFavorite': false,
      'quantity': quantity,
    };
  }

  ProductModel copyWith({
    String? categoryId,
    String? description,
    String? id,
    String? image,
    String? name,
    double? price,
    double? discount,
    String? status,
    int? quantity,
  }) {
    return ProductModel(
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      status: status ?? this.status,
      isFavorite: false,
      quantity: quantity ?? this.quantity,
    );
  }
}

String productModelToJson(ProductModel data) => json.encode(data.toJson());

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));
