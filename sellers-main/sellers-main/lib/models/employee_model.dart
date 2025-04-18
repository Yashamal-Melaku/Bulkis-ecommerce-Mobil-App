import 'dart:convert';

EmployeeModel employeeModelFromJson(String str) =>
    EmployeeModel.fromJson(json.decode(str));

String employeeModelToJson(EmployeeModel data) => json.encode(data.toJson());

class EmployeeModel {
  String? profile;
  String? idCard;
  bool approved;
  String role;
  String? employeeId;
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

  EmployeeModel({
    this.profile,
    this.idCard,
    required this.approved,
    required this.role,
    this.employeeId,
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

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        profile: json['profile'],
        idCard: json['idCard'],
        approved: json['approved'],
        role: json['role'],
        employeeId: json['id'],
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
        'profile': profile,
        'idCard': idCard,
        'approved': false,
        'role': role,
        'id': employeeId,
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

  EmployeeModel copyWith({
    String? firstName,
    String? profile,
  }) =>
      EmployeeModel(
        employeeId: employeeId,
        idCard: idCard,
        approved: approved,
        firstName: firstName ?? this.firstName,
        middleName: middleName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        profile: profile ?? this.profile,
        email: email,
        country: country,
        region: region,
        city: city,
        zone: zone,
        woreda: woreda,
        kebele: kebele,
        role: role,
      );
}
