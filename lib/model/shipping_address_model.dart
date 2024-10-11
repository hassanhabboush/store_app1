// To parse this JSON data, do
//
//     final shippingAddressModel = shippingAddressModelFromJson(jsonString);

import 'dart:convert';

ShippingAddressModel shippingAddressModelFromJson(String str) =>
    ShippingAddressModel.fromJson(json.decode(str));

String shippingAddressModelToJson(ShippingAddressModel data) =>
    json.encode(data.toJson());

class ShippingAddressModel {
  ShippingAddressModel({
    required this.data,
  });

  List<ShippingAddressItems> data;

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) =>
      ShippingAddressModel(
        data: List<ShippingAddressItems>.from(
            json["data"].map((x) => ShippingAddressItems.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ShippingAddressItems {
  ShippingAddressItems({
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
    this.state,
    this.country,
  });

  int? id;
  int? userId;
  int? countryId;
  int? stateId;
  String? fullName;
  String? phone;
  String? email;
  String? city;
  String? address;
  DateTime? createdAt;
  DateTime? updatedAt;
  Country? state;
  Country? country;

  factory ShippingAddressItems.fromJson(Map<String, dynamic> json) =>
      ShippingAddressItems(
        id: json["id"],
        userId: json["user_id"],
        countryId: json["country_id"],
        stateId: json["state_id"],
        fullName: json["full_name"],
        phone: json["phone"],
        email: json["email"],
        city: json["city"],
        address: json["address"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        state: Country.fromJson(json["state"]),
        country: Country.fromJson(json["country"]),
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
        "state": state?.toJson(),
        "country": country?.toJson(),
      };
}

class Country {
  Country({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
