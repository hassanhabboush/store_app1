// ignore_for_file: prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_app/services/common_service.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/view/utils/api_url.dart';

class PrivacyTermsService with ChangeNotifier {
  var termsData;
  var privacyData;

  fetchTerms(BuildContext context) async {
    debugPrint(termsData.toString());
    if (termsData != null) return;

    var connection = await checkConnection(context);
    if (!connection) return;
    var response = await http.get(Uri.parse(ApiUrl.termsUri));

    if (response.statusCode == 200) {
      termsData = jsonDecode(response.body)['page_content'];
      notifyListeners();
    }
  }

//============>

  fetchPrivacyData(BuildContext context) async {
    if (privacyData != null) return;

    var connection = await checkConnection(context);
    if (!connection) return;

    var response = await http.get(Uri.parse(ApiUrl.privacyPolicyUri));

    if (response.statusCode == 200) {
      privacyData = jsonDecode(response.body)['page_content'];
      notifyListeners();
    }
  }
}
