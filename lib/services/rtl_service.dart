// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/view/utils/api_url.dart';

class RtlService with ChangeNotifier {
  /// RTL support
  bool rtl = false;

  String currency = '\$';
  bool currencyAtLeft = true;

  bool alreadyLoaded = false;

  fetchCurrencyAndDirection(BuildContext context) async {
    if (alreadyLoaded == false) {
      var response = await http.get(Uri.parse(ApiUrl.rtlUri));
      if (response.statusCode == 201 || response.statusCode == 200) {
        var data = jsonDecode(response.body);
        currency = data['symbol'];
        currencyAtLeft = data['currencyPosition'] == "left" ? true : false;

        rtl = data['rtl'];

        alreadyLoaded == true;
        notifyListeners();
      } else {
        print('failed loading currency and rtl');
        print(response.body);
      }
    } else {
      //already loaded from server. no need to load again
    }
  }
}
