// To parse this JSON data, do
//
//     final searchModel = searchModelFromJson(jsonString);

import 'dart:convert';

SearchModel searchModelFromJson(String str) =>
    SearchModel.fromJson(json.decode(str));

String searchModelToJson(SearchModel data) => json.encode(data.toJson());

class SearchModel {
  SearchModel({
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

  List<ProductsOfSearch> data;
  int? currentPage;
  int? totalItems;
  int? totalPage;
  String? nextPage;
  dynamic previousPage;
  int? lastPage;
  int? perPage;
  String? path;
  int? currentList;
  int? from;
  int? to;
  bool? onFirstPage;
  bool? hasMorePages;
  List<String> links;

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
        data: List<ProductsOfSearch>.from(
            json["data"].map((x) => ProductsOfSearch.fromJson(x))),
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
        links: List<String>.from(json["links"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
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

class ProductsOfSearch {
  ProductsOfSearch({
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
  String? title;
  String? imgUrl;
  double? campaignPercentage;
  num? price;
  dynamic taxOSR;
  num? discountPrice;
  Badge? badge;
  bool? campaignProduct;
  int? stockCount;
  dynamic avgRatting;
  bool? isCartAble;
  dynamic vendorId;
  dynamic vendorName;
  int? categoryId;
  int? subCategoryId;
  List<int> childCategoryIds;

  factory ProductsOfSearch.fromJson(Map<String, dynamic> json) =>
      ProductsOfSearch(
        prdId: json["prd_id"],
        title: json["title"],
        imgUrl: json["img_url"],
        taxOSR: json["tax_options_sum_rate"],
        campaignPercentage: json["campaign_percentage"].toDouble(),
        price: json["price"] is String
            ? num.tryParse(json["price"])
            : json["price"],
        discountPrice: json["discount_price"] is String
            ? num.tryParse(json["discount_price"])
            : json["discount_price"],
        badge: Badge.fromJson(json["badge"]),
        campaignProduct: json["campaign_product"],
        stockCount: json["stock_count"] is String
            ? int.tryParse(json["stock_count"])
            : json["stock_count"],
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

  String? badgeName;
  String? image;

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
        badgeName: json["badge_name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "badge_name": badgeName,
        "image": image,
      };
}
