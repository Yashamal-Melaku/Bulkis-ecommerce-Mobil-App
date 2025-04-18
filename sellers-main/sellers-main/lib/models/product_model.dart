import 'dart:convert';

class ProductModel {
  String categoryId;
  String description;
  String id;
  String image;
  String name;
  double price;
  double discount;
  int quantity;
  double size;
  String measurement;
  String status;
  bool isFavorite;
  bool disabled;
  String productId;
  String employeeId;
  DateTime? startDate;
  DateTime? endDate;

  ProductModel({
    required this.categoryId,
    required this.description,
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.discount,
    required this.quantity,
    required this.size,
    required this.measurement,
    required this.status,
    required this.isFavorite,
    required this.disabled,
    required this.productId,
    required this.employeeId,
    this.startDate,
    this.endDate,
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
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      size: (json['size'] as num?)?.toDouble() ?? 0.0,
      measurement: json['measurement'] ?? '',
      status: json['status'] ?? '',
      isFavorite: false,
      disabled: json['disabled'] ?? false,
      productId: json['productId'] ?? '',
      employeeId: json['employeeId'] ?? '',
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
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
      'quantity': quantity,
      'size': size,
      'measurement': measurement,
      'status': status,
      'isFavorite': false,
      'disabled': false,
      'productId': productId,
      'employeeId': employeeId,
      'startDate':
          startDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'endDate': endDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  ProductModel copyWith({
    String? description,
    String? image,
    String? name,
    double? price,
    double? discount,
    int? quantity,
    double? size,
    String? measurement,
  }) {
    return ProductModel(
      categoryId: categoryId,
      description: description ?? this.description,
      id: id,
      image: image ?? this.image,
      name: name ?? this.name,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      measurement: measurement ?? this.measurement,
      status: status,
      isFavorite: false,
      disabled: false,
      productId: productId,
      employeeId: employeeId,
      startDate: DateTime.now(),
      endDate: endDate,
    );
  }
}

String productModelToJson(ProductModel data) => json.encode(data.toJson());

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));




// import 'dart:convert';

// class ProductModel {
//   String categoryId;
//   String description;
//   String id;
//   String image;
//   String name;
//   double price;
//   double discount;
//   int quantity;
//   double size;
//   String measurement;
//   String status;
//   bool isFavorite;
//   bool disabled;
//   String productId;
//   String employeeId;
//   // DateTime? startDate;
//   // DateTime? endDate;

//   ProductModel({
//     required this.categoryId,
//     required this.description,
//     required this.id,
//     required this.image,
//     required this.name,
//     required this.price,
//     required this.discount,
//     required this.quantity,
//     required this.size,
//     required this.measurement,
//     required this.status,
//     required this.isFavorite,
//     required this.disabled,
//     required this.productId,
//     required this.employeeId,
//     // this.startDate,
//     // this.endDate,
//   });

//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     return ProductModel(
//       categoryId: json['categoryId'] ?? '',
//       description: json['description'] ?? '',
//       id: json['id'] ?? '',
//       image: json['image'] ?? '',
//       name: json['name'] ?? '',
//       price: (json['price'] as num?)?.toDouble() ?? 0.0,
//       discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
//       quantity: (json['quantity'] as num?)?.toInt() ?? 1,
//       size: (json['size'] as num?)?.toDouble() ?? 0.0,
//       measurement: json['measurement'] ?? '',
//       status: json['status'] ?? '',
//       isFavorite: false,
//       disabled: json['disabled'] ?? false,
//       productId: json['productId'] ?? '',
//       employeeId: json['employeeId'] ?? '',
//       // startDate: DateTime.parse(json['startDate']).toLocal(),
//       // endDate: DateTime.parse(json['endDate']).toLocal(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'categoryId': categoryId,
//       'description': description,
//       'id': id,
//       'image': image,
//       'name': name,
//       'price': price,
//       'discount': discount,
//       'quantity': quantity,
//       'size': size,
//       'measurement': measurement,
//       'status': status,
//       'isFavorite': false,
//       'disabled': false,
//       'productId': productId,
//       'employeeId': employeeId,
//       // 'startDate': DateTime.now(),
//       // 'endDate': DateTime.now,
//     };
//   }

//   ProductModel copyWith({
//     String? description,
//     String? image,
//     String? name,
//     double? price,
//     double? discount,
//     int? quantity,
//     double? size,
//     String? measurement,
//   }) {
//     return ProductModel(
//         categoryId: categoryId,
//         description: description ?? this.description,
//         id: id,
//         image: image ?? this.image,
//         name: name ?? this.name,
//         price: price ?? this.price,
//         discount: discount ?? this.discount,
//         quantity: quantity ?? this.quantity,
//         size: size ?? this.size,
//         measurement: measurement ?? this.measurement,
//         status: status,
//         isFavorite: false,
//         disabled: false,
//         productId: productId,
//         employeeId: employeeId,
//         // startDate: DateTime.now(),
//         // endDate: endDate
//         );
//   }
// }

// String productModelToJson(ProductModel data) => json.encode(data.toJson());

// ProductModel productModelFromJson(String str) =>
//     ProductModel.fromJson(json.decode(str));
