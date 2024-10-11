import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_app/model/recent_product_model.dart';
import 'package:store_app/services/common_service.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/view/utils/api_url.dart';

class RecentProductService with ChangeNotifier {
  // =================>
  // =================>

  RecentProductModel? recentProducts;

  fetchRecentProducts(BuildContext context) async {
    if (recentProducts != null) return;

    var connection = await checkConnection(context);
    if (!connection) return;

    var response = await http.get(Uri.parse(ApiUrl.recentProductsUri));

    if (response.statusCode == 200) {
      var data = RecentProductModel.fromJson(jsonDecode(response.body));
      recentProducts = data;
      notifyListeners();
    }
  }

  // =============>
  // All featured products
  // ==============>

  List<RecentProductsList> allRecentProducts = [];

  bool isLoading = false;
  late int totalPages;
  bool noProductFound = false;

  int currentPage = 1;

  setLoadingStatus(bool status) {
    isLoading = status;
    notifyListeners();
  }

  setCurrentPage(newValue) {
    currentPage = newValue;
    notifyListeners();
  }

  setTotalPage(newPageNumber) {
    totalPages = newPageNumber;
    notifyListeners();
  }

  fetchAllRecentProducts(context, {bool isrefresh = false}) async {
    setLoadingStatus(true);

    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      print('isrefresh ran');
      allRecentProducts = [];
      notifyListeners();

      setCurrentPage(currentPage);
    } else {}
    var connection = await checkConnection(context);
    if (!connection) return;

    var response = await http
        .get(Uri.parse("${ApiUrl.recentProductsUri}?page=$currentPage"));

    setLoadingStatus(false);

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['data'].isNotEmpty) {
      var data = RecentProductModel.fromJson(jsonDecode(response.body));

      setTotalPage(data.lastPage);

      if (isrefresh) {
        print('refresh true');
        //if refreshed, then remove all service from list and insert new data
        allRecentProducts = [];
        allRecentProducts = data.data;
        notifyListeners();
      } else {
        print('add new data');
        for (int i = 0; i < data.data.length; i++) {
          allRecentProducts.add(data.data[i]);
        }
        notifyListeners();
      }

      currentPage++;
      setCurrentPage(currentPage);

      notifyListeners();
      return true;
    } else {
      if (allRecentProducts.isEmpty) {
        //if user searched for a product and not even a single product found
        //then show no product found
        //but we dont want to show it when some products were found and user
        //goes to the next page and there are no more products
        noProductFound = true;
        print(response.body);
      }
      print('no more data');

      return false;
    }
  }
}
