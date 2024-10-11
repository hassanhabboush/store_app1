// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_app/services/product_details_service.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common_service.dart';
import 'package:http/http.dart' as http;

class WriteReviewService with ChangeNotifier {
  bool isloading = false;
  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  Future<bool> leaveFeedback(BuildContext context,
      {rating, comment, productId}) async {
    var connection = await checkConnection(context);
    if (connection) {
      print('productId id $productId');

      setLoadingTrue();

      var data = jsonEncode({
        'id': productId,
        'rating': rating,
        'comment': comment,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      var response = await http.post(Uri.parse(ApiUrl.writeReviewUri),
          body: data, headers: header);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('review posted succesfully');

        showSnackBar(context, 'review posted succesfully', successColor);

        await Provider.of<ProductDetailsService>(context, listen: false)
            .fetchProductDetails(context, productId: productId);

        setLoadingFalse();

        Navigator.pop(context);

        return true;
      } else {
        print(response.body);
        showSnackBar(context, jsonDecode(response.body)['msg'], Colors.red);
        setLoadingFalse();
        return false;
      }
    } else {
      //internet connection off
      return false;
    }
  }
}
