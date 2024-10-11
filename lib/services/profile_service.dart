// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/model/profile_model.dart';
import 'package:store_app/services/auth_services/logout_service.dart';
import 'package:store_app/services/bottom_nav_service.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view/utils/constant_colors.dart';

class ProfileService with ChangeNotifier {
  bool isloading = false;

  ProfileModel? profileDetails;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  setEverythingToDefault() {
    profileDetails = null;
    notifyListeners();
  }

  Future<bool> getProfileDetails(BuildContext context,
      {bool loadAnyway = false}) async {
    if (loadAnyway == true) {
      //if from update profile page then load it anyway
      print('is from profile update page true');

      var res = await fetchData(context);
      return res;
    } else {
      //not from profile page. check if data already loaded
      if (profileDetails == null) {
        fetchData(context);
      } else {
        print('profile data already loaded');
      }

      return false;
    }
  }

  Future<bool> fetchData(BuildContext context) async {
    var connection = await checkConnection(context);
    if (!connection) return false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    setLoadingTrue();

    var header = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    var response =
        await http.get(Uri.parse(ApiUrl.profileDataUri), headers: header);

    if (response.statusCode == 200) {
      var data = ProfileModel.fromJson(jsonDecode(response.body));
      profileDetails = data;

      print('profile details is $profileDetails');

      setLoadingFalse();
      notifyListeners();

      return true;
    } else {
      setLoadingFalse();
      notifyListeners();
      return false;
    }
  }

  // =============>
  // delete account
  // =============>

  Future<bool> deleteProfile(BuildContext context,
      {required email, required pass}) async {
    var connection = await checkConnection(context);
    if (!connection) return false;

    var ln = Provider.of<TranslateStringService>(context, listen: false);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var userId = prefs.getInt('userId');

    setLoadingTrue();
    if (ApiUrl.siteUrl.toLowerCase().contains("www.hexfashion.xyz")) {
      await Future.delayed(const Duration(seconds: 2));
      showToast("This feature is turned off for demo app", blackColor);
      setLoadingFalse();
      return false;
    }
    var header = {
      "Accept": "application/json",
      // "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var data = {'email': email, 'password': pass};

    var response = await http.post(
        Uri.parse('${ApiUrl.deleteAccountUri}/$userId'),
        headers: header,
        body: data);

    print('delete profile response ${response.body}');

    setLoadingFalse();

    if (response.statusCode == 200) {
      showToast(
          ln.getString(ConstString.profileDeletedSuccessfully), Colors.black);

      // clear profile data =====>
      Future.delayed(const Duration(milliseconds: 500), () {
        Provider.of<ProfileService>(context, listen: false)
            .setEverythingToDefault();
      });

      //set landing page index to 0
      Provider.of<BottomNavService>(context, listen: false).setCurrentIndex(0);

      LogoutService().clear();
      Navigator.pop(context);
      Navigator.pop(context);

      return true;
    } else {
      showToast(ln.getString(ConstString.somethingWentWrong), Colors.black);
      return false;
    }
  }
}
