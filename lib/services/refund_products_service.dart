import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/model/refund_products_model.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RefundProductsService with ChangeNotifier {
  List<RefundProducts> productList = [];

  late int totalPages;
  int currentPage = 1;

  setCurrentPage(newValue) {
    currentPage = newValue;
    notifyListeners();
  }

  setTotalPage(newPageNumber) {
    totalPages = newPageNumber;
    notifyListeners();
  }

  Future<bool> fetchRefundProductList(context, {bool isrefresh = false}) async {
    if (isrefresh) {
      productList = [];

      notifyListeners();

      setCurrentPage(1);
    } else {}

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var connection = await checkConnection(context);
    if (!connection) return false;

    var response = await http.get(
        Uri.parse("${ApiUrl.refundProductsListUri}?page=$currentPage"),
        headers: header);

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['data'].isNotEmpty) {
      var data = RefundProductsModel.fromJson(jsonDecode(response.body));
      debugPrint(data.currentPage.toString());
      setTotalPage(data.lastPage);

      if (isrefresh) {
        productList = [];
        productList = data.data;
      } else {
        print('add new data');
        for (var element in data.data) {
          productList.add(element);
        }
      }

      currentPage++;
      setCurrentPage(currentPage);
      return true;
    } else {
      print(response.body);
      return false;
    }
  }
}
