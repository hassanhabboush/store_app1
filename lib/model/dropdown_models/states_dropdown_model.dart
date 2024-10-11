// To parse this JSON data, do
//
//     final statesDropdownModel = statesDropdownModelFromJson(jsonString);

import 'dart:convert';

StatesDropdownModel statesDropdownModelFromJson(dynamic str) =>
    StatesDropdownModel.fromJson(json.decode(str));

dynamic statesDropdownModelToJson(StatesDropdownModel data) =>
    json.encode(data.toJson());

class StatesDropdownModel {
  StatesDropdownModel({
    required this.state,
  });

  State state;

  factory StatesDropdownModel.fromJson(Map<dynamic, dynamic> json) =>
      StatesDropdownModel(
        state: State.fromJson(json["state"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "state": state.toJson(),
      };
}

class State {
  State({
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

  dynamic currentPage;
  List<Datum> data;
  dynamic firstPageUrl;
  dynamic from;
  dynamic lastPage;
  dynamic lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  dynamic path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  factory State.fromJson(Map<dynamic, dynamic> json) => State(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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

class Datum {
  Datum({
    this.id,
    this.name,
    this.countryId,
  });

  dynamic id;
  dynamic name;
  dynamic countryId;

  factory Datum.fromJson(Map<dynamic, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        countryId: json["country_id"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country_id": countryId,
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
