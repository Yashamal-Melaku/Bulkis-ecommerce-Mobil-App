import 'dart:convert';

SellerModel sellerModelFromJson(String str) =>
    SellerModel.fromJson(json.decode(str));

String sellerModelToJson(SellerModel data) => json.encode(data.toJson());

class SellerModel {
  bool? approved;
  String? role;
  String? image;
  String? id;
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? country;
  String? region;
  String? city;
  String? zone;
  String? woreda;
  String? kebele;

  SellerModel({
    this.approved,
    this.role,
    this.image,
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.country,
    this.region,
    this.city,
    this.zone,
    this.woreda,
    this.kebele,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) => SellerModel(
        approved: json['approved'],
        role: json['role'],
        image: json['image'],
        id: json['id'],
        firstName: json['firstName'],
        middleName: json['middleName'],
        lastName: json['lastName'],
        phoneNumber: json['phoneNumber'],
        email: json['email'],
        country: json['country'],
        region: json['region'],
        city: json['city'],
        zone: json['zone'],
        woreda: json['woreda'],
        kebele: json['kebele'],
      );
  Map<String, dynamic> toJson() => {
        'approved': false,
        'role': role,
        'image': image,
        'id': id,
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'email': email,
        'country': country,
        'region': region,
        'city': city,
        'zone': zone,
        'woreda': woreda,
        'kebele': kebele,
      };

  SellerModel copyWith({
    String? firstName,
    String? image,
  }) =>
      SellerModel(
        id: id,
        role: role,
        firstName: firstName ?? this.firstName,
        middleName: middleName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        image: image ?? this.image,
        email: email,
        country: country,
        region: region,
        city: city,
        zone: zone,
        woreda: woreda,
        kebele: kebele,
      );
}
