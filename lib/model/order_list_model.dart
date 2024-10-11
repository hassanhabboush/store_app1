// To parse this JSON data, do
//
//     final orderListModel = orderListModelFromJson(jsonString);

import 'dart:convert';

OrderListModel orderListModelFromJson(dynamic str) =>
    OrderListModel.fromJson(json.decode(str));

dynamic orderListModelToJson(OrderListModel data) => json.encode(data.toJson());

class OrderListModel {
  OrderListModel({
    this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  dynamic currentPage;
  List<OrderList> data;
  dynamic firstPageUrl;
  dynamic from;
  dynamic lastPage;
  dynamic lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  dynamic path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  factory OrderListModel.fromJson(Map<dynamic, dynamic> json) => OrderListModel(
        currentPage: json["current_page"],
        data: List<OrderList>.from(
            json["data"].map((x) => OrderList.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<dynamic, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class OrderList {
  OrderList({
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
    this.orderDetails,
    this.paymentMeta,
    this.shippingAddressId,
    this.selectedShippingOption,
    this.checkoutType,
    this.checkoutImagePath,
    this.createdAt,
    this.updatedAt,
  });

  dynamic? id;
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
  dynamic orderDetails;
  dynamic paymentMeta;
  dynamic shippingAddressId;
  dynamic selectedShippingOption;
  dynamic checkoutType;
  dynamic checkoutImagePath;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory OrderList.fromJson(Map<dynamic, dynamic> json) => OrderList(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        userId: json["user_id"],
        phone: json["phone"],
        country: json["country"],
        address: ["address"],
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
        orderDetails: json["order_details"],
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
        "order_details": orderDetails,
        "payment_meta": paymentMeta,
        "shipping_address_id": shippingAddressId,
        "selected_shipping_option": selectedShippingOption,
        "checkout_type": checkoutType,
        "checkout_image_path": checkoutImagePath,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  dynamic? url;
  dynamic? label;
  bool? active;

  factory Link.fromJson(Map<dynamic, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<dynamic, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}

class EnumValues<T> {
  Map<dynamic, T> map;
  late Map<T, dynamic> reverseMap;

  EnumValues(this.map);

  Map<T, dynamic> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
