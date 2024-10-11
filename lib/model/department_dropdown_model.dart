// To parse this JSON data, do
//
//     final departmentDropdownModel = departmentDropdownModelFromJson(jsonString);

import 'dart:convert';

DepartmentDropdownModel departmentDropdownModelFromJson(String str) =>
    DepartmentDropdownModel.fromJson(json.decode(str));

String departmentDropdownModelToJson(DepartmentDropdownModel data) =>
    json.encode(data.toJson());

class DepartmentDropdownModel {
  DepartmentDropdownModel({
    required this.data,
  });

  List<Datum> data;

  factory DepartmentDropdownModel.fromJson(Map<String, dynamic> json) =>
      DepartmentDropdownModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.status,
  });

  int? id;
  String? name;
  String? status;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
      };
}
