// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

import '../../view/auth/login/login.dart';
import '../../view/auth/reset_password/reset_pass_otp_page.dart';

class ResetPasswordService with ChangeNotifier {
  bool isloading = false;

  String? otpNumber;

  setOtp(newOtp) {
    otpNumber = newOtp;
    notifyListeners();
  }

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  sendOtp(email, BuildContext context, {isFromOtpPage = false}) async {
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

    setLoadingTrue();
    var response = await http.post(Uri.parse(ApiUrl.sendOtpUri),
        headers: header, body: data);
    if (response.statusCode == 200) {
      otpNumber = jsonDecode(response.body)['otp'];
      debugPrint('otp is $otpNumber');
      notifyListeners();
      if (!isFromOtpPage) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => ResetPassOtpPage(
              email: email,
            ),
          ),
        );
      }
      setLoadingFalse();
    } else {
      showToast(jsonDecode(response.body)['message'], Colors.black);
      setLoadingFalse();
    }
  }

  resetPassword(newPass, repeatNewPass, email, BuildContext context) async {
    var ln = Provider.of<TranslateStringService>(context, listen: false);

    if (newPass != repeatNewPass) {
      showToast(ln.getString(ConstString.passDidntMatch), Colors.black);
      return;
    }

    var connection = await checkConnection(context);
    if (!connection) return false;

    //internet connection is on
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json"
    };

    var data = jsonEncode({'email': email, 'password': newPass});

    print(data);
    setLoadingTrue();

    var response = await http.post(Uri.parse(ApiUrl.resetPassUri),
        headers: header, body: data);

    print(response.body);
    if (response.statusCode == 200) {
      showToast(
          ln.getString(ConstString.passChangedSuccessfully), Colors.black);
      setLoadingFalse();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const LoginPage(),
        ),
      );
    } else {
      showToast(jsonDecode(response.body)['message'], Colors.black);
      setLoadingFalse();
    }
  }
}
