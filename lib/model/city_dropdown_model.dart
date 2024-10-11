import 'dart:convert';

CityDropdownModel cityDropdownModelFromJson(String str) =>
    CityDropdownModel.fromJson(json.decode(str));

String cityDropdownModelToJson(CityDropdownModel data) =>
    json.encode(data.toJson());

class CityDropdownModel {
  Cities? cities;

  CityDropdownModel({
    this.cities,
  });

  factory CityDropdownModel.fromJson(Map json) => CityDropdownModel(
        cities: json["cities"] == null ? null : Cities.fromJson(json["cities"]),
      );
  factory CityDropdownModel.fromJsonSearched(Map json) => CityDropdownModel(
        cities: json["city"] == null ? null : Cities.fromJson(json["city"]),
      );

  Map<String, dynamic> toJson() => {
        "cities": cities?.toJson(),
      };
}

class Cities {
  List<Datum>? data;
  dynamic nextPageUrl;

  Cities({
    this.data,
    this.nextPageUrl,
  });

  factory Cities.fromJson(Map<String, dynamic> json) => Cities(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        nextPageUrl: json["next_page_url"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
      };
}

class Datum {
  dynamic id;
  String? name;
  dynamic stateId;

  Datum({
    this.id,
    this.name,
    this.stateId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        stateId: json["state_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "state_id": stateId,
      };
}
