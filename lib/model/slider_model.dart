// To parse this JSON data, do
//
//     final sliderModel = sliderModelFromJson(jsonString);

import 'dart:convert';

SliderModel sliderModelFromJson(String str) =>
    SliderModel.fromJson(json.decode(str));

String sliderModelToJson(SliderModel data) => json.encode(data.toJson());

class SliderModel {
  SliderModel({
    required this.data,
  });

  List<SliderItem> data;

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
        data: List<SliderItem>.from(
            json["data"].map((x) => SliderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SliderItem {
  SliderItem({
    this.title,
    this.description,
    this.image,
    this.buttonUrl,
    this.buttonText,
    this.campaign,
    this.category,
  });

  String? title;
  String? description;
  String? image;
  String? buttonUrl;
  String? buttonText;
  dynamic campaign;
  String? category;

  factory SliderItem.fromJson(Map<String, dynamic> json) => SliderItem(
        title: json["title"],
        description: json["description"],
        image: json["image"],
        buttonUrl: json["button_url"],
        buttonText: json["button_text"],
        campaign: json["campaign"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "image": image,
        "button_url": buttonUrl,
        "button_text": buttonText,
        "campaign": campaign,
        "category": category,
      };
}
