import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_app/model/shipping_address_model.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ShippingListService with ChangeNotifier {
  List<ShippingAddressItems> addressList = [];

  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  setEverythingToDefault() {
    addressList = [];
    Future.delayed(const Duration(microseconds: 500), () {
      notifyListeners();
    });
  }

  fetchAddressList({bool isFromAddAddressPage = false}) async {
    if (addressList.isEmpty || isFromAddAddressPage == true) {
      setEverythingToDefault();
      setLoadingTrue();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      var response =
          await http.get(Uri.parse(ApiUrl.shipAddressListUri), headers: header);

      setLoadingFalse();

      if (response.statusCode == 200) {
        var data = ShippingAddressModel.fromJson(jsonDecode(response.body));

        addressList = data.data;
      } else {
        print('address list fetch error ${response.body}');
      }
    } else {
      //already loaded from api
    }
  }
}
