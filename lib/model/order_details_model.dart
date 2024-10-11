// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(dynamic str) =>
    OrderDetailsModel.fromJson(json.decode(str));

dynamic orderDetailsModelToJson(OrderDetailsModel data) =>
    json.encode(data.toJson());

class OrderDetailsModel {
  OrderDetailsModel({
    required this.data,
  });

  Data data;

  factory OrderDetailsModel.fromJson(Map<dynamic, dynamic> json) =>
      OrderDetailsModel(
        data: Data.fromJson(json["data"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.name,
    this.email,
    this.userId,
    this.phone,
    this.country,
    this.address,
    this.city,
    this.state,
    this.zipcode,
    this.message,
    this.coupon,
    this.couponDiscounted,
    this.totalAmount,
    this.status,
    this.paymentStatus,
    this.paymentGateway,
    this.paymentTrack,
    this.transactionId,
    this.paymentMeta,
    this.shippingAddressId,
    this.selectedShippingOption,
    this.checkoutType,
    this.checkoutImagePath,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic name;
  dynamic email;
  dynamic userId;
  dynamic phone;
  dynamic country;
  dynamic address;
  dynamic city;
  dynamic state;
  dynamic zipcode;
  dynamic message;
  dynamic coupon;
  dynamic couponDiscounted;
  dynamic totalAmount;
  dynamic status;
  dynamic paymentStatus;
  dynamic paymentGateway;
  dynamic paymentTrack;
  dynamic transactionId;
  dynamic paymentMeta;
  dynamic shippingAddressId;
  dynamic selectedShippingOption;
  dynamic checkoutType;
  dynamic checkoutImagePath;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        userId: json["user_id"],
        phone: json["phone"],
        country: json["country"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        zipcode: json["zipcode"],
        message: json["message"],
        coupon: json["coupon"],
        couponDiscounted: json["coupon_discounted"],
        totalAmount: json["total_amount"],
        status: json["status"],
        paymentStatus: json["payment_status"],
        paymentGateway: json["payment_gateway"],
        paymentTrack: json["payment_track"],
        transactionId: json["transaction_id"],
        paymentMeta: json["payment_meta"],
        shippingAddressId: json["shipping_address_id"],
        selectedShippingOption: json["selected_shipping_option"],
        checkoutType: json["checkout_type"],
        checkoutImagePath: json["checkout_image_path"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "user_id": userId,
        "phone": phone,
        "country": country,
        "address": address,
        "city": city,
        "state": state,
        "zipcode": zipcode,
        "message": message,
        "coupon": coupon,
        "coupon_discounted": couponDiscounted,
        "total_amount": totalAmount,
        "status": status,
        "payment_status": paymentStatus,
        "payment_gateway": paymentGateway,
        "payment_track": paymentTrack,
        "transaction_id": transactionId,
        "payment_meta": paymentMeta,
        "shipping_address_id": shippingAddressId,
        "selected_shipping_option": selectedShippingOption,
        "checkout_type": checkoutType,
        "checkout_image_path": checkoutImagePath,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
