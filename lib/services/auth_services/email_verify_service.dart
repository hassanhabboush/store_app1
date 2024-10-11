// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_app/services/auth_services/login_service.dart';
import 'package:store_app/services/auth_services/reset_password_service.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/home/landing_page.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/others_helper.dart';

import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class EmailVerifyService with ChangeNotifier {
  bool isloading = false;

  bool verifyOtpLoading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  Future<bool> sendOtpForEmailValidation(
      email, BuildContext context, token) async {
    var connection = await checkConnection(context);
    if (!connection) return false;

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    var data = jsonEncode({
      'email': email,
    });

    var response = await http.post(Uri.parse(ApiUrl.sendOtpUri),
        headers: header, body: data);
    if (response.statusCode == 200) {
      var otpNumber = jsonDecode(response.body)['otp'];
      Provider.of<ResetPasswordService>(context, listen: false)
          .setOtp(otpNumber);

      debugPrint('otp is $otpNumber');
      notifyListeners();

      return true;
    } else {
      print(response.body);
      showToast(jsonDecode(response.body)['message'], Colors.black);

      return false;
    }
  }

  verifyOtpAndLogin(
      enteredOtp, BuildContext context, email, password, token, userId) async {
    var ln = Provider.of<TranslateStringService>(context, listen: false);

    var otpNumber =
        Provider.of<ResetPasswordService>(context, listen: false).otpNumber;
    if (otpNumber != null) {
      if (enteredOtp == otpNumber) {
        //Set Loading true
        verifyOtpLoading = true;
        notifyListeners();

        var header = {
          //if header type is application/json then the data should be in jsonEncode method
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        };
        var data = jsonEncode({'user_id': userId, 'email_verified': 1});

        var response = await http.post(Uri.parse(ApiUrl.otpSuccessUri),
            headers: header, body: data);

        //Set loading false
        verifyOtpLoading = false;
        notifyListeners();

        print(response.body);

        if (response.statusCode == 200) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const LandingPage(),
            ),
          );

          //save the details for later login
          LoginService().saveDetails(email, password, token, userId);
        } else {
          print(response.body);
          showToast(
              ln.getString(ConstString.youEnteredOtpCorrectButSomethingWrong),
              Colors.black);
        }
      } else {
        showToast(ConstString.otpDidntMatch, Colors.black);
      }
    } else {
      showToast(ConstString.otpFailedToSend, Colors.black);
    }
  }
}
