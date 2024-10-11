// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:store_app/model/search_model.dart';
import 'package:store_app/services/category_service.dart';
import 'package:store_app/services/child_category_service.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/filter_color_size_service.dart';
import 'package:store_app/services/subcategory_service.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:provider/provider.dart';

class SearchProductService with ChangeNotifier {
  List<ProductsOfSearch> productList = [];
  bool noProductFound = false;
  bool isLoading = false;

  String minPrice = '0.0';
  String maxPrice = '1000.0';
  double rating = 5;

  late int totalPages;

  int currentPage = 1;

  String searchText = '';

  var categoryName;
  var subCategoryName;
  var childCategoryName;

  setSearchText(value) {
    searchText = value;
    notifyListeners();
  }

  setMinPrice(v) {
    minPrice = v;
    notifyListeners();
  }

  setMaxPrice(v) {
    maxPrice = v;
    notifyListeners();
  }

  setRating(v) {
    rating = v;
    notifyListeners();
  }

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

  searchProducts(context,
      {bool isrefresh = false, bool isSearching = false}) async {
    if (isSearching) {
      setEverythingToDefault();
    }

    setLoadingStatus(true);

    setCategories(context);

    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      print('isrefresh ran');
      productList = [];
      notifyListeners();

      setCurrentPage(currentPage);
    } else {}
    var connection = await checkConnection(context);
    if (!connection) return;

    print('max $maxPrice');
    print('min pr $minPrice');

    var selectedSize =
        Provider.of<FilterColorSizeService>(context, listen: false)
            .selectedSizeCode;
    var selectedColor =
        Provider.of<FilterColorSizeService>(context, listen: false)
            .selectedColorName;

    var response = await http.get(Uri.parse(
        "${ApiUrl.searchUri}?name=$searchText&color=$selectedColor&size=$selectedSize&page=$currentPage&category=$categoryName&sub_category=$subCategoryName&child_category=$childCategoryName&from_price=$minPrice&to_price=$maxPrice&rating=$rating"));

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

  setCategories(BuildContext context) {
    categoryName =
        Provider.of<CategoryService>(context, listen: false).selectedCategory;

    subCategoryName = Provider.of<SubCategoryService>(context, listen: false)
        .selectedSubCategory;

    childCategoryName =
        Provider.of<ChildCategoryService>(context, listen: false)
            .selectedChildCategory;

    if (categoryName == null || categoryName == ConstString.selectCategory) {
      categoryName = '';
    }
    if (subCategoryName == null ||
        subCategoryName == ConstString.selectSubCategory) {
      subCategoryName = '';
    }
    if (childCategoryName == null ||
        childCategoryName == ConstString.selectChildCategory) {
      childCategoryName = '';
    }
  }
}
