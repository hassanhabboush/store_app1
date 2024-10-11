import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

import 'product_db_service.dart';

class CheckoutService {
  formatCart(BuildContext context) async {
    List products = await ProductDbService().allCartProducts();
    Map formatData = {};
    for (var element in products) {
      print(element);
      final String rowId = md5
          .convert(utf8.encode(
              element["id"].toString() + element['attributes'].toString()))
          .toString();
      final attributes = jsonDecode(element['attributes']);
      final usedCategories = {
        "category": element['category'],
        "subcategory": element['subcategory'],
        "childcategory": element['childCategory'],
      };
      var options = {
        "variant_id": element['variantId'],
        "attributes": [],
        //     element['attributes'] == "{}" || element['attributes'] == {}
        //         ? []
        //         : element['attributes'],
        "image": element['thumbnail'],
        "tax_options_sum_rate":
            element['tax_options_sum_rate'].toString() == "null"
                ? "0"
                : element['tax_options_sum_rate'],
        "used_categories": usedCategories
      };
      if (attributes['Size'] != null) {
        options.putIfAbsent('size_name', () => attributes['Size']);
      }
      if (attributes['color_code'] != null) {
        options.putIfAbsent('color_code', () => attributes['color_code']);
      }
      if (attributes['Color'] != null) {
        options.putIfAbsent('color_name', () => attributes['Color']);
      }
      formatData.putIfAbsent(
          rowId,
          () => {
                "rowId": rowId,
                "id": element["productId"],
                "name": element["title"],
                "qty": element["qty"],
                "price": element["priceWithAttr"],
                "options": options,
                "subtotal": element['priceWithAttr'] ?? 1 * element['qty'] ?? 12
              });
    }
    print(formatData);

    return formatData;
  }

  final targetMap = {
    "0d8ab1a9b4e28059dee9ac88da20b667": {
      "rowId": "0d8ab1a9b4e28059dee9ac88da20b667",
      "id": "239",
      "name": "towal set",
      "qty": "1",
      "price": 660,
      "weight": 0,
      "options": {
        "variant_id": "448",
        "color_name": "Blue",
        "size_name": "Large",
        "attributes": {"Fabric": "Cotton"},
        "image": "438",
        "used_categories": {"category": 12, "subcategory": 42}
      },
      "discount": 0,
      "tax": 0,
      "subtotal": 660
    }
  };
}
