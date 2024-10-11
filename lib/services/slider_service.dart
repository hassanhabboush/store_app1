// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/model/slider_model.dart';
import 'package:store_app/view/home/no_app_permission_page.dart';
import 'package:store_app/view/utils/api_url.dart';

class SliderService with ChangeNotifier {
  List<SliderItem> sliderImageList = [];
  bool noItems = false;
  fetchSlider(BuildContext context) async {
    if (sliderImageList.isNotEmpty) return;
    // bool noItems = false;
    // notifyListeners();
    try {
      var response = await http.get(Uri.parse(ApiUrl.sliderUri));

      if (response.statusCode == 200) {
        var data = SliderModel.fromJson(jsonDecode(response.body));

        sliderImageList = data.data;
        // notifyListeners();
      } else if (response.statusCode == 403) {
        //no app permission
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const NoAppPermissionPage(),
          ),
        );
      } else {
        print('slider fetch error ${response.body}');
      }
    } finally {
      print('slider has no item is $noItems');
      noItems = sliderImageList.isEmpty;
      notifyListeners();
    }
  }
}
