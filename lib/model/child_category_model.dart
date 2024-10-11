// To parse this JSON data, do
//
//     final childCategoryModel = childCategoryModelFromJson(jsonString);

import 'dart:convert';

ChildCategoryModel childCategoryModelFromJson(String str) =>
    ChildCategoryModel.fromJson(json.decode(str));

String childCategoryModelToJson(ChildCategoryModel data) =>
    json.encode(data.toJson());

class ChildCategoryModel {
  ChildCategoryModel({
    required this.childCategories,
  });

  List<ChildCategory> childCategories;

  factory ChildCategoryModel.fromJson(Map<String, dynamic> json) =>
      ChildCategoryModel(
        childCategories: List<ChildCategory>.from(
            json["childCategories"].map((x) => ChildCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "childCategories":
            List<dynamic>.from(childCategories.map((x) => x.toJson())),
      };
}

class ChildCategory {
  ChildCategory({
    this.id,
    this.name,
    this.imageId,
    this.subCategoryId,
    this.imageUrl,
  });

  int? id;
  String? name;
  int? imageId;
  int? subCategoryId;
  String? imageUrl;

  factory ChildCategory.fromJson(Map<String, dynamic> json) => ChildCategory(
        id: json["id"],
        name: json["name"],
        imageId: json["image_id"],
        subCategoryId: json["sub_category_id"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_id": imageId,
        "sub_category_id": subCategoryId,
        "image_url": imageUrl,
      };
}
