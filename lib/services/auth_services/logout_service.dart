// ignore_for_file: use_build_context_synchronously

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:store_app/services/bottom_nav_service.dart';
import 'package:store_app/services/profile_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common_service.dart';

class LogoutService with ChangeNotifier {
  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  Future<bool> logout(BuildContext context) async {
    var connection = await checkConnection(context);
    if (!connection) return false;

    var ln = Provider.of<TranslateStringService>(context, listen: false);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    setLoadingTrue();
    var response = await http.post(
      Uri.parse(ApiUrl.logoutUri),
      headers: header,
    );
    setLoadingFalse();
    if (response.statusCode == 200) {
      notifyListeners();

      Navigator.pop(context);

      showToast(ln.getString(ConstString.userLoggedOut), Colors.black);

      // clear profile data =====>
      Future.delayed(const Duration(milliseconds: 500), () {
        Provider.of<ProfileService>(context, listen: false)
            .setEverythingToDefault();
      });

      //set landing page index to 0
      Provider.of<BottomNavService>(context, listen: false).setCurrentIndex(0);

      clear();
      return true;
    } else {
      print(response.body);
      showToast(ln.getString(ConstString.somethingWentWrong), Colors.black);
      return false;
    }
  }

  //clear saved email, pass and token
  clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
