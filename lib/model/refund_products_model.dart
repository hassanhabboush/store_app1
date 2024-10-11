// To parse this JSON data, do
//
//     final refundProductsModel = refundProductsModelFromJson(jsonString);

import 'dart:convert';

RefundProductsModel refundProductsModelFromJson(dynamic str) =>
    RefundProductsModel.fromJson(json.decode(str));

dynamic refundProductsModelToJson(RefundProductsModel data) =>
    json.encode(data.toJson());

class RefundProductsModel {
  RefundProductsModel({
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

  var currentPage;
  List<RefundProducts> data;
  dynamic firstPageUrl;
  var from;
  var lastPage;
  dynamic lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  dynamic path;
  var perPage;
  dynamic prevPageUrl;
  var to;
  var total;

  factory RefundProductsModel.fromJson(Map<dynamic, dynamic> json) =>
      RefundProductsModel(
        currentPage: json["current_page"],
        data: List<RefundProducts>.from(
            json["data"].map((x) => RefundProducts.fromJson(x))),
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

class RefundProducts {
  RefundProducts({
    this.id,
    this.userId,
    this.orderId,
    this.productId,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.user,
    this.product,
  });

  var id;
  var userId;
  var orderId;
  var productId;
  DateTime? createdAt;
  DateTime? updatedAt;
  var status;
  User? user;
  Product? product;

  factory RefundProducts.fromJson(Map<dynamic, dynamic> json) => RefundProducts(
        id: json["id"],
        userId: json["user_id"],
        orderId: json["order_id"],
        productId: json["product_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        status: json["status"],
        user: User.fromJson(json["user"]),
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "order_id": orderId,
        "product_id": productId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "status": status,
        "user": user?.toJson(),
        "product": product?.toJson(),
      };
}

class Product {
  Product({
    this.id,
    this.name,
    this.slug,
    this.summary,
    this.description,
    this.imageId,
    this.price,
    this.salePrice,
    this.cost,
    this.badgeId,
    this.brandId,
    this.statusId,
    this.productType,
    this.soldCount,
    this.minPurchase,
    this.maxPurchase,
    this.isRefundable,
    this.isInHouse,
    this.isInventoryWarnAble,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.inventoryDetailCount,
  });

  var id;
  dynamic name;
  dynamic slug;
  dynamic summary;
  dynamic description;
  dynamic imageId;
  var price;
  var salePrice;
  var cost;
  var badgeId;
  var brandId;
  var statusId;
  var productType;
  dynamic soldCount;
  var minPurchase;
  var maxPurchase;
  var isRefundable;
  var isInHouse;
  var isInventoryWarnAble;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  var inventoryDetailCount;

  factory Product.fromJson(Map<dynamic, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        summary: json["summary"],
        description: json["description"],
        imageId: json["image_id"],
        price: json["price"],
        salePrice: json["sale_price"],
        cost: json["cost"],
        badgeId: json["badge_id"],
        brandId: json["brand_id"],
        statusId: json["status_id"],
        productType: json["product_type"],
        soldCount: json["sold_count"],
        minPurchase: json["min_purchase"],
        maxPurchase: json["max_purchase"],
        isRefundable: json["is_refundable"],
        isInHouse: json["is_in_house"],
        isInventoryWarnAble: json["is_inventory_warn_able"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        inventoryDetailCount: json["inventory_detail_count"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "summary": summary,
        "description": description,
        "image_id": imageId,
        "price": price,
        "sale_price": salePrice,
        "cost": cost,
        "badge_id": badgeId,
        "brand_id": brandId,
        "status_id": statusId,
        "product_type": productType,
        "sold_count": soldCount,
        "min_purchase": minPurchase,
        "max_purchase": maxPurchase,
        "is_refundable": isRefundable,
        "is_in_house": isInHouse,
        "is_inventory_warn_able": isInventoryWarnAble,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "inventory_detail_count": inventoryDetailCount,
      };
}

class User {
  User({
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
  });

  var id;
  dynamic name;
  dynamic email;
  dynamic emailVerifiedAt;
  dynamic username;
  var emailVerified;
  dynamic emailVerifyToken;
  dynamic mobile;
  dynamic company;
  dynamic address;
  dynamic city;
  dynamic state;
  dynamic image;
  dynamic country;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory User.fromJson(Map<dynamic, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        username: json["username"],
        emailVerified: json["email_verified"],
        emailVerifyToken: json["email_verify_token"],
        mobile: json["mobile"],
        company: json["company"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        image: json["image"],
        country: json["country"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<dynamic, dynamic> toJson() => {
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
      };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  dynamic url;
  dynamic label;
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
