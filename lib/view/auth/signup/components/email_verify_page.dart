// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:store_app/services/auth_services/email_verify_service.dart';
import 'package:store_app/services/auth_services/reset_password_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/others_helper.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class EmailVerifyPage extends StatefulWidget {
  const EmailVerifyPage({
    Key? key,
    required this.email,
    required this.pass,
    required this.token,
    required this.userId,
  }) : super(key: key);

  final email;
  final pass;
  final token;
  final userId;

  @override
  _EmailVerifyPageState createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends State<EmailVerifyPage> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  String currentText = "";
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        appBar: appbarCommon(ConstString.verifyEmail, context, () {
          Navigator.pop(context);
        }),
        body: Consumer<TranslateStringService>(
          builder: (context, ln, child) => Consumer<EmailVerifyService>(
            builder: (context, provider, child) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80.0,
                    width: 80.0,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/email-circle.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  titleCommon(ln.getString(ConstString.enterFourDigit)),
                  const SizedBox(
                    height: 13,
                  ),
                  paragraphCommon(
                      ln.getString(ConstString.enterFourDigitToVerifyEmail),
                      textAlign: TextAlign.center),
                  const SizedBox(
                    height: 33,
                  ),
                  Form(
                    child: PinCodeTextField(
                      appContext: context,
                      length: 4,
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      showCursor: true,
                      cursorColor: greyFive,

                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 70,
                          activeFillColor: Colors.white,
                          borderWidth: 1.5,
                          selectedColor: primaryColor,
                          activeColor: primaryColor,
                          inactiveColor: greyFive),
                      animationDuration: const Duration(milliseconds: 200),
                      // backgroundColor: Colors.white,
                      // enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      onCompleted: (otp) {
                        provider.verifyOtpAndLogin(
                          otp,
                          context,
                          widget.email,
                          widget.pass,
                          widget.token,
                          widget.userId,
                        );
                      },
                      onChanged: (value) {
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),
                  ),

                  //Loading bar
                  provider.verifyOtpLoading == true
                      ? Container(
                          margin: const EdgeInsets.only(top: 15, bottom: 5),
                          alignment: Alignment.center,
                          child: showLoading(primaryColor),
                        )
                      : Container(),

                  const SizedBox(
                    height: 13,
                  ),
                  Consumer<ResetPasswordService>(
                    builder: (context, provider, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        provider.isloading == false
                            ? RichText(
                                text: TextSpan(
                                  text: ln.getString(ConstString.didntReceive) +
                                      '  ',
                                  style: const TextStyle(
                                      color: Color(0xff646464), fontSize: 14),
                                  children: <TextSpan>[
                                    TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            provider.sendOtp(
                                                widget.email, context,
                                                isFromOtpPage: true);
                                          },
                                        text:
                                            ln.getString(ConstString.sendAgain),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: primaryColor,
                                        )),
                                  ],
                                ),
                              )
                            : showLoading(primaryColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
