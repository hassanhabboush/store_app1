// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.userDetails,
  });

  UserDetails userDetails;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        userDetails: UserDetails.fromJson(json["user_details"]),
      );

  Map<String, dynamic> toJson() => {
        "user_details": userDetails.toJson(),
      };
}

class UserDetails {
  UserDetails({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.username,
    this.emailVerified,
    this.emailVerifyToken,
    this.mobile,
    this.company,
    this.address,
    this.city,
    this.state,
    this.image,
    this.country,
    this.createdAt,
    this.updatedAt,
    this.profileImageUrl,
    this.userCountry,
    this.userState,
    this.deliveryAddress,
    this.postalCode,
  });

  dynamic id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  String? username;
  int? emailVerified;
  String? emailVerifyToken;
  String? postalCode;
  String? mobile;
  String? company;
  String? address;
  String? state;
  String? image;
  String? country;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? profileImageUrl;
  User? userCountry;
  User? userState;
  User? city;
  DeliveryAddress? deliveryAddress;

  factory UserDetails.fromJson(Map<String, dynamic>? json) => UserDetails(
        id: json?["id"],
        name: json?["name"],
        email: json?["email"],
        emailVerifiedAt: json?["email_verified_at"],
        username: json?["username"],
        emailVerified: json?["email_verified"],
        emailVerifyToken: json?["email_verify_token"],
        mobile: json?["mobile"],
        company: json?["company"],
        address: json?["address"],
        state: json?["state"],
        image: json?["image"],
        country: json?["country"],
        postalCode: json?["postal_code"],
        createdAt: DateTime.parse(json?["created_at"]),
        updatedAt: DateTime.parse(json?["updated_at"]),
        profileImageUrl: json?["profile_image_url"],
        userCountry: json?["user_country"] != null
            ? User.fromJson(json?["user_country"])
            : null,
        city: json?["user_city"] != null
            ? User.fromJson(json?["user_city"])
            : null,
        userState: json?["user_state"] != null
            ? User.fromJson(json?["user_state"])
            : null,
        deliveryAddress: json?["delivery_address"] != null
            ? DeliveryAddress.fromJson(json?["delivery_address"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "username": username,
        "email_verified": emailVerified,
        "email_verify_token": emailVerifyToken,
        "mobile": mobile,
        "company": company,
        "address": address,
        "city": city,
        "state": state,
        "image": image,
        "country": country,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "profile_image_url": profileImageUrl,
        "user_country": userCountry?.toJson(),
        "user_state": userState?.toJson(),
        "delivery_address": deliveryAddress?.toJson(),
      };
}

class DeliveryAddress {
  DeliveryAddress({
    this.id,
    this.userId,
    this.countryId,
    this.stateId,
    this.fullName,
    this.phone,
    this.email,
    this.city,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.postCode,
  });

  int? id;
  int? userId;
  int? countryId;
  int? stateId;
  String? fullName;
  String? phone;
  String? email;
  String? city;
  String? postCode;
  String? address;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(
        id: json["id"],
        userId: json["user_id"],
        countryId: json["country_id"],
        stateId: json["state_id"],
        fullName: json["full_name"],
        postCode: json["postal_code"]?.toString(),
        phone: json["phone"],
        email: json["email"],
        city: json["city"],
        address: json["address"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "country_id": countryId,
        "state_id": stateId,
        "full_name": fullName,
        "phone": phone,
        "email": email,
        "city": city,
        "address": address,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class User {
  User({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.countryId,
    this.stateId,
  });

  dynamic id;
  String? name;
  dynamic status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic countryId;
  dynamic stateId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        countryId: json["country_id"],
        stateId: json["state_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "country_id": countryId,
      };
}
