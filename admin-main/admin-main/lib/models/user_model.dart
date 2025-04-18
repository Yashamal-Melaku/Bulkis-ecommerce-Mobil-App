import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? image;
  String id;
  String name;
  String email;

  UserModel({
    this.image,
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        image: json['image'],
        id: json['id'],
        name: json['name'],
        email: json['email'],
      );
  Map<String, dynamic> toJson() => {
        'image': image,
        'id': id,
        'name': name,
        'email': email,
      };

  UserModel copyWith({
    String? name,
    image,
  }) =>
      UserModel(
          id: id,
          name: name ?? this.name,
          image: image ?? this.image,
          email: email);
}
