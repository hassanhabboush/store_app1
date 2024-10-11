import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/auth/login/login.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

class SignupHelper {
  haveAccount(BuildContext context) {
    return Consumer<TranslateStringService>(
      builder: (context, ln, child) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: ln.getString(ConstString.haveAccount) + '  ',
              style: const TextStyle(color: Color(0xff646464), fontSize: 14),
              children: <TextSpan>[
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                    text: ln.getString(ConstString.signIn),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: primaryColor,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //
  phoneFieldDecoration(BuildContext context) {
    var phoneTxt = Provider.of<TranslateStringService>(context, listen: false)
        .getString(ConstString.phoneNumber);
    var enterPhoneTxt =
        Provider.of<TranslateStringService>(context, listen: false)
            .getString(ConstString.enterPhoneNumber);
    return InputDecoration(
        labelText: phoneTxt,
        filled: true,
        fillColor: Colors.transparent,

        // hintTextDirection: TextDirection.rtl,
        labelStyle: const TextStyle(color: greyFour, fontSize: 14),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: inputFieldBorderColor),
            borderRadius: BorderRadius.circular(globalBorderRadius)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor)),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: warningColor)),
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor)),
        hintText: enterPhoneTxt,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 18));
  }
}
