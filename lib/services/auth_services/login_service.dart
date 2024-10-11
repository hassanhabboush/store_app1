// ignore_for_file: avoid_print, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/services/bottom_nav_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/home/landing_page.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common_service.dart';

class LoginService with ChangeNotifier {
  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  Future<bool> login(email, pass, BuildContext context, bool keepLoggedIn,
      {isFromLoginPage = true,
      isFromCheckout = false,
      isFromSettingsPage = false}) async {
    var connection = await checkConnection(context);
    if (connection) {
      var ln = Provider.of<TranslateStringService>(context, listen: false);

      setLoadingTrue();
      var data = jsonEncode({
        'username': email,
        'password': pass,
      });
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json"
      };

      var response = await http.post(Uri.parse(ApiUrl.loginUri),
          body: data, headers: header);
      debugPrint(response.body.toString());
      if (response.statusCode == 200) {
        setLoadingFalse();

        String token = jsonDecode(response.body)['token'];
        int userId = jsonDecode(response.body)['users']['id'];

        if (keepLoggedIn) {
          saveDetails(email, pass, token, userId);
        } else {
          setKeepLoggedInFalseSaveToken(token);
        }

        print(response.body);

        if (isFromCheckout) {
          // Provider.of<ProfileService>(context, listen: false).fetchData();
          return true;
        }

        Provider.of<BottomNavService>(context, listen: false).resetIndex();

        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const LandingPage(),
          ),
        );

        return true;
      } else {
        print(response.body);
        //Login unsuccessful ==========>
        if (isFromLoginPage) {
          showToast(ln.getString(ConstString.invalidEmailOrPass), warningColor);
        }
        setLoadingFalse();
        return false;
      }
    } else {
      //internet off
      return false;
    }
  }

  saveDetails(String email, pass, String token, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setBool('keepLoggedIn', true);
    prefs.setString("pass", pass);
    prefs.setString("token", token);
    prefs.setInt('userId', userId);
    print('token is $token');
    print('user id is $userId');
  }

  setKeepLoggedInFalseSaveToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('keepLoggedIn', false);
    prefs.setString("token", token);
  }
}
