// To parse this JSON data, do
//
//     final shippingCostModel = shippingCostModelFromJson(jsonString);

import 'dart:convert';

ShippingCostModel shippingCostModelFromJson(dynamic str) =>
    ShippingCostModel.fromJson(json.decode(str));

dynamic shippingCostModelToJson(ShippingCostModel data) =>
    json.encode(data.toJson());

class ShippingCostModel {
  ShippingCostModel({
    this.tax,
    required this.shippingOptions,
    this.defaultShippingOptions,
    this.productTaxes,
  });

  num? tax;
  List<DefaultShippingOptions> shippingOptions;
  DefaultShippingOptions? defaultShippingOptions;
  dynamic productTaxes;

  factory ShippingCostModel.fromJson(Map<dynamic, dynamic> json) =>
      ShippingCostModel(
          tax: json["tax"] is String ? num.tryParse(json["tax"]) : json["tax"],
          shippingOptions: List<DefaultShippingOptions>.from(
              json["shipping_options"]
                  .map((x) => DefaultShippingOptions.fromJson(x))),
          defaultShippingOptions: json["default_shipping_options"] != null
              ? DefaultShippingOptions.fromJson(
                  json["default_shipping_options"])
              : null,
          productTaxes: json["product_tax_info"]);

  Map<dynamic, dynamic> toJson() => {
        // "tax": tax,
        "shipping_options":
            List<dynamic>.from(shippingOptions.map((x) => x.toJson())),
        "default_shipping_options": defaultShippingOptions?.toJson(),
      };
}

class DefaultShippingOptions {
  DefaultShippingOptions({
    this.id,
    this.name,
    this.zoneId,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
    this.options,
  });

  dynamic id;
  dynamic name;
  dynamic zoneId;
  dynamic isDefault;
  DateTime? createdAt;
  DateTime? updatedAt;
  Options? options;

  factory DefaultShippingOptions.fromJson(Map<dynamic, dynamic> json) =>
      DefaultShippingOptions(
        id: json["id"],
        name: json["name"],
        zoneId: json["zone_id"],
        isDefault: json["is_default"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        options: Options.fromJson(json["options"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "name": name,
        "zone_id": zoneId,
        "is_default": isDefault,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "options": options?.toJson(),
      };
}

class Options {
  Options({
    this.id,
    this.title,
    this.shippingMethodId,
    this.status,
    this.taxStatus,
    this.settingPreset,
    this.cost,
    this.minimumOrderAmount,
    this.coupon,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic title;
  dynamic shippingMethodId;
  dynamic status;
  dynamic taxStatus;
  dynamic settingPreset;
  dynamic cost;
  dynamic minimumOrderAmount;
  dynamic coupon;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Options.fromJson(Map<dynamic, dynamic> json) => Options(
        id: json["id"],
        title: json["title"],
        shippingMethodId: json["shipping_method_id"] is String
            ? int.tryParse(json["shipping_method_id"])
            : json["shipping_method_id"],
        status: json["status"],
        taxStatus: json["tax_status"],
        settingPreset: json["setting_preset"],
        cost: json["cost"],
        minimumOrderAmount: json["minimum_order_amount"],
        coupon: json["coupon"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "title": title,
        "shipping_method_id": shippingMethodId,
        "status": status,
        "tax_status": taxStatus,
        "setting_preset": settingPreset,
        "cost": cost,
        "minimum_order_amount": minimumOrderAmount,
        "coupon": coupon,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
