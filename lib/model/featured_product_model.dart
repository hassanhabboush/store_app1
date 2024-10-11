// To parse this JSON data, do
//
//     final featuredProductsModel = featuredProductsModelFromJson(jsondynamic);

import 'dart:convert';

FeaturedProductsModel featuredProductsModelFromJson(dynamic str) =>
    FeaturedProductsModel.fromJson(json.decode(str));

dynamic featuredProductsModelToJson(FeaturedProductsModel data) =>
    json.encode(data.toJson());

class FeaturedProductsModel {
  FeaturedProductsModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  List<FeaturedProducts> data;
  Links links;
  Meta meta;

  factory FeaturedProductsModel.fromJson(Map<dynamic, dynamic> json) =>
      FeaturedProductsModel(
        data: List<FeaturedProducts>.from(
            json["data"].map((x) => FeaturedProducts.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "links": links.toJson(),
        "meta": meta.toJson(),
      };
}

class FeaturedProducts {
  FeaturedProducts({
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
    this.taxOSR,
    required this.childCategoryIds,
  });

  dynamic prdId;
  dynamic title;
  dynamic imgUrl;
  dynamic campaignPercentage;
  dynamic price;
  dynamic discountPrice;
  Badge? badge;
  dynamic campaignProduct;
  dynamic stockCount;
  dynamic avgRatting;
  dynamic taxOSR;
  dynamic isCartAble;
  dynamic vendorId;
  dynamic vendorName;
  dynamic categoryId;
  dynamic subCategoryId;
  List<dynamic> childCategoryIds;

  factory FeaturedProducts.fromJson(Map<dynamic, dynamic> json) =>
      FeaturedProducts(
        prdId: json["prd_id"],
        title: json["title"],
        imgUrl: json["img_url"],
        taxOSR: json["tax_options_sum_rate"],
        campaignPercentage: json["campaign_percentage"] != null
            ? json["campaign_percentage"].toDouble()
            : null,
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
            List<dynamic>.from(json["child_category_ids"].map((x) => x)),
      );

  Map<dynamic, dynamic> toJson() => {
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

  dynamic badgeName;
  dynamic image;

  factory Badge.fromJson(Map<dynamic, dynamic> json) => Badge(
        badgeName: json["badge_name"],
        image: json["image"],
      );

  Map<dynamic, dynamic> toJson() => {
        "badge_name": badgeName,
        "image": image,
      };
}

class Links {
  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  dynamic first;
  dynamic last;
  dynamic prev;
  dynamic next;

  factory Links.fromJson(Map<dynamic, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
      );

  Map<dynamic, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
      };
}

class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    required this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  dynamic currentPage;
  dynamic from;
  dynamic lastPage;
  List<Link> links;
  dynamic path;
  dynamic perPage;
  dynamic to;
  dynamic total;

  factory Meta.fromJson(Map<dynamic, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<dynamic, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
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
  dynamic active;

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
