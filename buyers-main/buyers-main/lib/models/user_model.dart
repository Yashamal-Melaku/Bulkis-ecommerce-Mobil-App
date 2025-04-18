import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? image;
  String id;
  String name;
  String email;
  String phoneNumber;

  UserModel(
      {this.image,
      required this.id,
      required this.name,
      required this.email,
      required this.phoneNumber});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        image: json['image'],
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phoneNumber: json['phoneNumber'].toString(),
      );
  Map<String, dynamic> toJson() => {
        'image': image,
        'id': id,
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber
      };

  UserModel copyWith({
    String? name,
    image,
  }) =>
      UserModel(
          id: id,
          name: name ?? this.name,
          image: image ?? this.image,
          email: email,
          phoneNumber: phoneNumber);
}
