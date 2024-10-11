import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:store_app/model/search_model.dart';
import 'package:store_app/services/common_service.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/view/utils/api_url.dart';

class ProductByCategoryService with ChangeNotifier {
  List<ProductsOfSearch> productList = [];
  bool noProductFound = false;
  bool isLoading = false;
  late int totalPages;

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

  setEverythingToDefault() {
    currentPage = 1;
    productList = [];
    noProductFound = false;
    notifyListeners();
  }

  fetchProductByCategory(context, categoryName,
      {bool isrefresh = false}) async {
    setLoadingStatus(true);

    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      print('isrefresh ran');
      productList = [];
      notifyListeners();

      setCurrentPage(currentPage);
    }
    var connection = await checkConnection(context);
    if (!connection) return;

    var response = await http.get(Uri.parse(
        "${ApiUrl.searchUri}?name=&page=$currentPage&category=$categoryName&sub_category=&child_category=&min_price=&max_price=&rating="));

    setLoadingStatus(false);

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['data'].isNotEmpty) {
      var data = SearchModel.fromJson(jsonDecode(response.body));

      setTotalPage(data.lastPage);

      if (isrefresh) {
        print('refresh true');
        //if refreshed, then remove all service from list and insert new data
        productList = [];
        productList = data.data;
        notifyListeners();
      } else {
        print('add new data');
        for (int i = 0; i < data.data.length; i++) {
          productList.add(data.data[i]);
        }
        notifyListeners();
      }

      currentPage++;
      setCurrentPage(currentPage);

      notifyListeners();
      return true;
    } else {
      if (productList.isEmpty) {
        //if user searched for a product and not even a single product found
        //then show no product found
        //but we dont want to show it when some products were found and user
        //goes to the next page and there are no more products
        noProductFound = true;
        print(response.body);
      }
      notifyListeners();
      print('no more data');

      return false;
    }
  }
}
