import 'package:flutter/material.dart';
import 'package:store_app/services/auth_services/reset_password_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/others_helper.dart';

import 'package:provider/provider.dart';

import '../../view/auth/reset_password/reset_password_page.dart';

class ResetPasswordOtpService {
  checkOtp(enteredOtp, email, BuildContext context) {
    var ln = Provider.of<TranslateStringService>(context, listen: false);

    var otp =
        Provider.of<ResetPasswordService>(context, listen: false).otpNumber;
    if (otp != null) {
      if (enteredOtp == otp) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => ResetPasswordPage(
              email: email,
            ),
          ),
        );
      } else {
        showToast(ln.getString(ConstString.otpDidntMatch), Colors.black);
      }
    } else {
      showToast(ln.getString(ConstString.somethingWentWrong), Colors.black);
    }
  }
}
