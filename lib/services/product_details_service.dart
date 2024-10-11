// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_app/model/product_details_model.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/view/utils/others_helper.dart';

class ProductDetailsService with ChangeNotifier {
  //

  ProductDetailsModel? productDetails;
  int ratingCount = 0;
  bool inStock = true;
  bool isLoading = false;
  int qty = 1;
  List<String> selectedInventorySetIndex = [];
  List<String> inventoryKeys = [];
  Map<String, Map<String, List<String>>> allAtrributes = {};
  List selectedAttributes = [];
  Map<String, List<Map<String, dynamic>>> inventorySet = {};
  Map<String, dynamic> selectedInventorySet = {};
  List<String> inventoryHash = [];
  bool cartAble = false;
  var additionalInfoImage;
  var variantId;
  num productSalePrice = 0;
  int? selectedIndex;
  var selectedInventoryHash;
  Map additionalInventoryInfo = {};

  increaseQty() {
    qty = qty + 1;
    notifyListeners();
  }

  decreaseQty() {
    if (qty == 1) return;
    qty = qty - 1;
    notifyListeners();
  }

  setLoadingStatus(bool status) {
    isLoading = status;
    notifyListeners();
  }

  clearProductDetails() {
    print('clearing product details');
    productDetails = null;
    // reviewing = false;
    productSalePrice = 0;
    productDetails = null;
    qty = 1;
    // descriptionExpand = false;
    // aDescriptionExpand = false;
    // reviewExpand = false;
    additionalInfoImage = null;
    // quantity = 1;
    selectedInventorySetIndex = [];
    selectedInventorySet = {};
    cartAble = false;
    variantId = null;
    inventoryKeys = [];
    allAtrributes = {};
    selectedAttributes = [];
    // reviewing = false;
    // refreshpage = false;
    // productDetails!.product.productGalleryImage = [];

    // notifyListeners();
  }

  clearSelection() {
    selectedAttributes = [];
    additionalInfoImage = null;
    cartAble = false;
    variantId = null;
    productSalePrice = (productDetails!.product?.salePrice ?? 0).toDouble();
    selectedInventorySetIndex = [];
    selectedAttributes = [];
    selectedInventorySet = {};
    notifyListeners();
  }

  setProductInventorySet(List<String>? value) {
    if (selectedInventorySetIndex != value) {}
    if (selectedInventorySetIndex.isEmpty) {
      selectedInventorySetIndex = value ?? [];
      notifyListeners();
      return;
    }

    if (selectedInventorySetIndex.isNotEmpty &&
        selectedInventorySetIndex.length > value!.length) {
      selectedInventorySetIndex = value;
      notifyListeners();
      return;
    }

    List<String> tempList = [];
    if (selectedInventorySetIndex != value) {
      tempList = selectedInventorySetIndex.where((v) {
        return value!.contains(v);
      }).toList();
      if (tempList.isNotEmpty) {
        selectedInventorySetIndex = tempList;
      }
    }
  }

  addAdditionalPrice() {
    // print(selectedInventorySetIndex);

    bool setMatched = true;
    debugPrint(selectedInventorySetIndex.toString());
    for (int i = 0; i < selectedInventorySetIndex.length; i++) {
      setMatched = true;
      Map sfsdf = {};
      selectedInventorySet = productDetails!
          .productInventorySet[int.parse(selectedInventorySetIndex[i])];
      selectedInventorySet.remove('Color');
      for (var e in selectedInventorySet.values) {
        // print(i);
        List<dynamic> confirmingSelectedDeta = selectedAttributes;
        // confirmingSelectedDeta.add(selectedInventorySet['hash']);
        // confirmingSelectedDeta.add(selectedInventorySet['Color_name']);
        if (!confirmingSelectedDeta.contains(e)) {
          setMatched = false;
          continue;
        }
      }
      final mapData = {};

      if (setMatched) {
        print('Inventory..............');
        selectedIndex = int.parse(selectedInventorySetIndex[i]);
        print(productDetails!
            .productInventorySet[int.parse(selectedInventorySetIndex[i])]);
        selectedInventorySetIndex = [selectedInventorySetIndex[i]];

        break;
      }
    }
    if (setMatched) {
      selectedInventoryHash = inventoryHash[selectedIndex!];
      // print('hash..............');
      // print(selectedInventoryHash);
      // print(productDetails!.productInventorySet[selectedIndex!]);
      productSalePrice +=
          (productDetails!.additionalInfoStore![selectedInventoryHash] == null
                      ? 0
                      : productDetails!
                          .additionalInfoStore![selectedInventoryHash]!
                          .additionalPrice)
                  ?.toDouble() ??
              0;
      additionalInfoImage =
          productDetails!.additionalInfoStore![selectedInventoryHash] == null
              ? ''
              : productDetails!
                  .additionalInfoStore![selectedInventoryHash]!.image;
      additionalInfoImage =
          additionalInfoImage == '' ? null : additionalInfoImage;
      variantId =
          productDetails?.additionalInfoStore![selectedInventoryHash]?.pidId;
      cartAble = true;
      selectedInventorySet.remove('hash');
      // print(selectedInventorySet);
      debugPrint(selectedInventoryHash.toString());
      print(variantId);
      notifyListeners();
      return;
    }
    print('Inventory..............');
    // print(productDetails!.productInventorySet[selectedIndex!]);
    print('outside..............');
    cartAble = false;
    variantId = null;
    productSalePrice =
        productDetails!.product!.campaignProduct?['campaign_price'] != null
            ? double.parse(
                productDetails!.product!.campaignProduct?['campaign_price'])
            : productDetails!.product!.salePrice ?? 0;
    additionalInfoImage = null;
    selectedInventorySet = {};
    selectedInventoryHash = null;
    notifyListeners();
  }

  addSelectedAttribute(value) {
    if (selectedAttributes.contains(value)) {
      return;
    }
    allAtrributes.keys.toList().forEach((element) {
      print(allAtrributes[element]?.keys.toList());
    });
    selectedAttributes.add(value);

    notifyListeners();
  }

  bool isASelected(value) {
    return selectedAttributes.contains(value);
  }

  bool isInSet(fieldName, value, List<String>? list) {
    bool result = false;
    if (selectedInventorySetIndex.isEmpty) {
      result = true;
    }
    for (var element in allAtrributes[fieldName]!.keys.toList()) {
      if (selectedAttributes.contains(element) && value == element) {
        result == true;
        return true;
      }
      if (selectedAttributes.contains(element) && value != element) {
        result == false;
        return false;
      }
    }
    if (result) {
      return result;
    }
    for (var element in list ?? ['0']) {
      // if (selectedInventorySet.isNotEmpty &&
      //     !selectedInventorySet.values.toList().contains(element)) {
      //   print(element);
      //   result = false;
      //   break;
      // }
      // print('$element $selectedInventorySetIndex');
      if (selectedInventorySetIndex.contains(element)) {
        result = true;
        break;
      }
    }
    return result;
  }

  bool deselect(List<String>? value, List<String>? list) {
    bool result = false;
    for (var element in value!) {
      if ((list!.contains(element))) {
        result = true;
      }
    }
    return result;
  }

  addToMap(value, int index, Map<String, List<String>> map) {
    if (value == null || map == {}) {
      return;
    }
    if (!map[value]!.contains(index.toString())) {
      map.update(value, (valuee) {
        valuee.add(index.toString());
        return valuee;
      });
    }

    return map;
  }

  fetchProductDetails(BuildContext context, {required productId}) async {
    //check internet connection
    var connection = await checkConnection(context);
    if (!connection) return;

    clearProductDetails();

    print('product id $productId');

    //
    var header = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    // try {
    setLoadingStatus(true);

    var response = await http.get(
        Uri.parse('${ApiUrl.productDetailsUri}/$productId'),
        headers: header);

    if (response.statusCode == 200) {
      productDetails = ProductDetailsModel.fromJson(jsonDecode(response.body));
      final productInvenSet = productDetails!.productInventorySet;
      productSalePrice =
          productDetails!.product!.campaignProduct?['campaign_price'] != null
              ? double.parse(
                  productDetails!.product!.campaignProduct?['campaign_price'])
              : productDetails!.product!.salePrice ?? 0;
      productInvenSet.forEach((element) {
        print(element['hash']);
        inventoryHash.add(element['hash']);
        element.remove('Color');
        element.remove('hash');
        final keys = element.keys;
        for (var e in keys) {
          if (inventoryKeys.contains(e)) {
            return;
          }
          inventoryKeys.add(e);
        }
      });

      {
        for (var e in inventoryKeys) {
          int index = 0;
          List<String> list;
          Map<String, List<String>> map = {};
          for (dynamic element in productInvenSet) {
            if (element.containsKey(e)) {
              map.putIfAbsent(element[e], () => []);
              // print(map);
              if (allAtrributes.containsKey(e)) {
                allAtrributes.update(
                    e, (value) => addToMap(element[e], index, value));
              }
              allAtrributes.putIfAbsent(e, () {
                return addToMap(element[e], index, map);
              });
            }

            // addToList(cheeseList, element.cheese);
            index++;
          }
        }
      }

      additionalInventoryInfo = productDetails!.additionalInfoStore ?? {};
      if (productDetails!.additionalInfoStore == null) {
        cartAble = true;
        // variantId =
        //     productDetails?.additionalInfoStore![selectedInventoryHash]?.pidId;
      }

      print(allAtrributes);
      notifyListeners();
      return;
    } else {
      showToast('Error fetching product details', Colors.black);
      print(response.body);
    }
    print(allAtrributes);

    ratingCount = productDetails?.ratings.length ?? 0;
    inStock =
        productDetails?.product?.inventory?.stockCount == 0 ? false : true;
    // } catch (e) {
    //   showToast('Something went wrong', Colors.black);
    //   print(e.toString());
    // }
  }
}
