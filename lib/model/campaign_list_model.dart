// To parse this JSON data, do
//
//     final campaignListModel = campaignListModelFromJson(jsonString);

import 'dart:convert';

CampaignListModel campaignListModelFromJson(String str) =>
    CampaignListModel.fromJson(json.decode(str));

String campaignListModelToJson(CampaignListModel data) =>
    json.encode(data.toJson());

class CampaignListModel {
  CampaignListModel({
    required this.data,
  });

  List<CampaignListItem> data;

  factory CampaignListModel.fromJson(Map<String, dynamic> json) =>
      CampaignListModel(
        data: List<CampaignListItem>.from(
            json["data"].map((x) => CampaignListItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CampaignListItem {
  CampaignListItem({
    this.id,
    this.title,
    this.subtitle,
    this.image,
    this.startDate,
    this.endDate,
  });

  int? id;
  String? title;
  String? subtitle;
  String? image;
  DateTime? startDate;
  DateTime? endDate;

  factory CampaignListItem.fromJson(Map<String, dynamic> json) =>
      CampaignListItem(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        image: json["image"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "image": image,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
      };
}
