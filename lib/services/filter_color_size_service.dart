import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:http/http.dart' as http;

class FilterColorSizeService with ChangeNotifier {
  var colorSize;

  var selectedColorName = '';
  var selectedSizeCode = '';

  int selectedColorIndex = -1;
  int selectedSizeIndex = -1;

  setSelectedColorName(v) {
    selectedColorName = v;
    notifyListeners();
  }

  setSelectedSizeCode(v) {
    selectedSizeCode = v;
    notifyListeners();
  }

  setColorIndex(v) {
    selectedColorIndex = v;
    notifyListeners();
  }

  setSizeIndex(v) {
    selectedSizeIndex = v;
    notifyListeners();
  }

  setDefault() {
    selectedColorName = '';
    selectedSizeCode = '';
    selectedColorIndex = -1;
    selectedSizeIndex = -1;
    notifyListeners();
  }

  //
  fetchColorSize(BuildContext context) async {
    if (colorSize != null) return;

    var connection = await checkConnection(context);
    if (!connection) return;

    var response = await http.get(Uri.parse(ApiUrl.searchItemsUri));

    if (response.statusCode == 200) {
      colorSize = jsonDecode(response.body);
      notifyListeners();
    } else {
      print('error fetching color size${response.body}');
    }
  }
}
