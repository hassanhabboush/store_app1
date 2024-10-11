// ignore_for_file: prefer_typing_uninitialized_variables, prefer_collection_literals

import 'dart:convert';

class AddtocartModel {
  late var productId;
  late String title;
  late String thumbnail;
  late String? color;
  late String? size;
  var discountPrice;
  var oldPrice;
  var priceWithAttr;
  late int qty;

  var category;
  var subcategory;
  var childCategory;
  var attributes;
  var variantId;
  var taxOSR;

  cartMap() {
    var mapping = Map<String, dynamic>();
    mapping['productId'] = productId;
    mapping['title'] = title;
    mapping['thumbnail'] = thumbnail;
    mapping['discountPrice'] = discountPrice;
    mapping['oldPrice'] = oldPrice;
    mapping['priceWithAttr'] = priceWithAttr;
    mapping['qty'] = qty;
    mapping['color'] = color;
    mapping['size'] = size;
    mapping['category'] = category;
    mapping['subcategory'] = subcategory;
    mapping['childCategory'] = childCategory;
    mapping['attributes'] = jsonEncode(attributes);
    mapping['variantId'] = variantId;
    mapping['tax_options_sum_rate'] = taxOSR;
    return mapping;
  }
}
