// To parse this JSON data, do
//
//     final recentProductModel = recentProductModelFromJson(jsondynamic);

import 'dart:convert';

RecentProductModel recentProductModelFromJson(dynamic str) =>
    RecentProductModel.fromJson(json.decode(str));

dynamic recentProductModelToJson(RecentProductModel data) =>
    json.encode(data.toJson());

class RecentProductModel {
  RecentProductModel({
    required this.data,
    this.currentPage,
    this.totalItems,
    this.totalPage,
    this.nextPage,
    this.previousPage,
    this.lastPage,
    this.perPage,
    this.path,
    this.currentList,
    this.from,
    this.to,
    this.onFirstPage,
    this.hasMorePages,
    required this.links,
  });

  List<RecentProductsList> data;
  dynamic currentPage;
  dynamic totalItems;
  dynamic totalPage;
  dynamic nextPage;
  dynamic previousPage;
  dynamic lastPage;
  dynamic perPage;
  dynamic path;
  dynamic currentList;
  dynamic from;
  dynamic to;
  bool? onFirstPage;
  bool? hasMorePages;
  List<dynamic> links;

  factory RecentProductModel.fromJson(Map<dynamic, dynamic> json) =>
      RecentProductModel(
        data: List<RecentProductsList>.from(
            json["data"].map((x) => RecentProductsList.fromJson(x))),
        currentPage: json["current_page"],
        totalItems: json["total_items"],
        totalPage: json["total_page"],
        nextPage: json["next_page"],
        previousPage: json["previous_page"],
        lastPage: json["last_page"],
        perPage: json["per_page"],
        path: json["path"],
        currentList: json["current_list"],
        from: json["from"],
        to: json["to"],
        onFirstPage: json["on_first_page"],
        hasMorePages: json["hasMorePages"],
        links: List<dynamic>.from(json["links"].map((x) => x)),
      );

  Map<dynamic, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "current_page": currentPage,
        "total_items": totalItems,
        "total_page": totalPage,
        "next_page": nextPage,
        "previous_page": previousPage,
        "last_page": lastPage,
        "per_page": perPage,
        "path": path,
        "current_list": currentList,
        "from": from,
        "to": to,
        "on_first_page": onFirstPage,
        "hasMorePages": hasMorePages,
        "links": List<dynamic>.from(links.map((x) => x)),
      };
}

class RecentProductsList {
  RecentProductsList({
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
    required this.childCategoryIds,
    this.taxOSR,
  });

  dynamic prdId;
  dynamic title;
  dynamic imgUrl;
  dynamic campaignPercentage;
  dynamic price;
  dynamic discountPrice;
  dynamic badge;
  bool? campaignProduct;
  dynamic stockCount;
  dynamic avgRatting;
  bool? isCartAble;
  dynamic taxOSR;
  dynamic vendorId;
  dynamic vendorName;
  dynamic categoryId;
  dynamic subCategoryId;
  List<dynamic> childCategoryIds;

  factory RecentProductsList.fromJson(Map<dynamic, dynamic> json) =>
      RecentProductsList(
        prdId: json["prd_id"],
        title: json["title"],
        imgUrl: json["img_url"],
        taxOSR: json["tax_options_sum_rate"],
        campaignPercentage: json["campaign_percentage"].toDouble(),
        price: json["price"],
        discountPrice: json["discount_price"],
        badge: json["badge"],
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
