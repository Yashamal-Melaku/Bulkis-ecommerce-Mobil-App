import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  String image;
  String id;
  String name;

  CategoryModel({
    required this.image,
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        image: json['image'],
        id: json['id'],
        name: json['name'],
      );
  Map<String, dynamic> toJson() => {
        'image': image,
        'id': id,
        'name': name,
      };

  CategoryModel copyWith({
    String? name,
    String? image,
  }) =>
      CategoryModel(
        id: id,
        name: name ?? this.name,
        image: image ?? this.image,
      );
}
