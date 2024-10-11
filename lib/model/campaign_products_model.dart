// To parse this JSON data, do
//
//     final campaignProductsModel = campaignProductsModelFromJson(jsonString);

import 'dart:convert';

CampaignProductsModel campaignProductsModelFromJson(String str) =>
    CampaignProductsModel.fromJson(json.decode(str));

String campaignProductsModelToJson(CampaignProductsModel data) =>
    json.encode(data.toJson());

class CampaignProductsModel {
  CampaignProductsModel({
    required this.products,
    required this.campaignInfo,
  });

  List<CampaignSingleProduct> products;
  CampaignInfo? campaignInfo;

  factory CampaignProductsModel.fromJson(Map<String, dynamic> json) =>
      CampaignProductsModel(
        products: List<CampaignSingleProduct>.from(
            json["products"].map((x) => CampaignSingleProduct.fromJson(x))),
        campaignInfo: json["campaign_info"] == null
            ? null
            : CampaignInfo.fromJson(json["campaign_info"]),
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "campaign_info": campaignInfo?.toJson(),
      };
}

class CampaignInfo {
  CampaignInfo({
    this.id,
    this.title,
    this.subtitle,
    this.image,
    this.startDate,
    this.endDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.adminId,
    this.vendorId,
    this.type,
  });

  var id;
  var title;
  var subtitle;
  var image;
  DateTime? startDate;
  DateTime? endDate;
  var status;
  DateTime? createdAt;
  DateTime? updatedAt;
  var adminId;
  dynamic vendorId;
  var type;

  factory CampaignInfo.fromJson(Map<String, dynamic> json) => CampaignInfo(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        image: json["image"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        adminId: json["admin_id"],
        vendorId: json["vendor_id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "image": image,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "admin_id": adminId,
        "vendor_id": vendorId,
        "type": type,
      };
}

class CampaignSingleProduct {
  CampaignSingleProduct({
    this.prdId,
    this.title,
    this.imgUrl,
    this.campaignPercentage,
    this.price,
    this.discountPrice,
    this.badge,
    this.campaignProduct,
    this.stockCount,
    this.avgRatting,
    this.isCartAble,
    this.vendorId,
    this.vendorName,
    this.categoryId,
    this.subCategoryId,
    this.childCategoryIds,
    this.taxOSR,
  });

  var prdId;
  var title;
  var imgUrl;
  var campaignPercentage;
  var price;
  var discountPrice;
  Badge? badge;
  dynamic taxOSR;
  bool? campaignProduct;
  var stockCount;
  dynamic avgRatting;
  bool? isCartAble;
  dynamic vendorId;
  dynamic vendorName;
  var categoryId;
  var subCategoryId;
  var childCategoryIds;

  factory CampaignSingleProduct.fromJson(Map<String, dynamic> json) =>
      CampaignSingleProduct(
        prdId: json["prd_id"],
        title: json["title"],
        imgUrl: json["img_url"],
        taxOSR: json["tax_options_sum_rate"],
        campaignPercentage: json["campaign_percentage"].toDouble(),
        price: json["price"],
        discountPrice: json["discount_price"],
        badge: Badge.fromJson(json["badge"]),
        campaignProduct: json["campaign_product"],
        stockCount: json["stock_count"],
        avgRatting: json["avg_ratting"],
        isCartAble: json["is_cart_able"],
        vendorId: json["vendor_id"],
        vendorName: json["vendor_name"],
        categoryId: json["category_id"],
        subCategoryId: json["sub_category_id"],
        childCategoryIds:
            List<int>.from(json["child_category_ids"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "prd_id": prdId,
        "title": title,
        "img_url": imgUrl,
        "campaign_percentage": campaignPercentage,
        "price": price,
        "discount_price": discountPrice,
        "badge": badge?.toJson(),
        "campaign_product": campaignProduct,
        "stock_count": stockCount,
        "avg_ratting": avgRatting,
        "is_cart_able": isCartAble,
        "vendor_id": vendorId,
        "vendor_name": vendorName,
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "child_category_ids":
            List<dynamic>.from(childCategoryIds.map((x) => x)),
      };
}

class Badge {
  Badge({
    this.badgeName,
    this.image,
  });

  var badgeName;
  var image;

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
        badgeName: json["badge_name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "badge_name": badgeName,
        "image": image,
      };
}
