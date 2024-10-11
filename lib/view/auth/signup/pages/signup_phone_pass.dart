// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:store_app/services/auth_services/signup_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/custom_input.dart';
import 'package:provider/provider.dart';

class SignupPhonePass extends StatefulWidget {
  const SignupPhonePass(
      {Key? key,
      required this.passController,
      required this.phoneController,
      required this.confirmPassController})
      : super(key: key);

  final passController;
  final confirmPassController;
  final phoneController;

  @override
  _SignupPhonePassState createState() => _SignupPhonePassState();
}

class _SignupPhonePassState extends State<SignupPhonePass> {
  late bool _newpasswordVisible;
  late bool _confirmNewPassswordVisible;

  @override
  void initState() {
    super.initState();
    _newpasswordVisible = false;
    _confirmNewPassswordVisible = false;
  }

  final _formKey = GlobalKey<FormState>();

  bool keepLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslateStringService>(
      builder: (context, ln, child) => Consumer<SignupService>(
        builder: (context, provider, child) => Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phone number field
              labelCommon(ConstString.phone),

              CustomInput(
                controller: widget.phoneController,
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return ln.getString(ConstString.plzEnterPhone);
                  }
                  return null;
                },
                hintText: ln.getString(ConstString.enterPhoneNumber),
                isNumberField: true,
                paddingHorizontal: 17,
                textInputAction: TextInputAction.next,
              ),

              //New password =========================>
              labelCommon(ConstString.pass),

              Container(
                  margin: const EdgeInsets.only(bottom: 19),
                  child: TextFormField(
                    controller: widget.passController,
                    textInputAction: TextInputAction.next,
                    obscureText: !_newpasswordVisible,
                    style: const TextStyle(fontSize: 14),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ln.getString(ConstString.plzEnterYourPass);
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            _newpasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              _newpasswordVisible = !_newpasswordVisible;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: inputFieldBorderColor),
                            borderRadius:
                                BorderRadius.circular(globalBorderRadius)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor)),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: warningColor)),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor)),
                        hintText: ln.getString(ConstString.enterPass),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18)),
                  )),

              const SizedBox(
                height: 5,
              ),
              //Confirm New password =========================>
              labelCommon(ConstString.confirmPass),

              Container(
                  margin: const EdgeInsets.only(bottom: 19),
                  child: TextFormField(
                    controller: widget.confirmPassController,
                    textInputAction: TextInputAction.next,
                    obscureText: !_confirmNewPassswordVisible,
                    style: const TextStyle(fontSize: 14),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ln.getString(ConstString.plzRetypePass);
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            _confirmNewPassswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              _confirmNewPassswordVisible =
                                  !_confirmNewPassswordVisible;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: inputFieldBorderColor),
                            borderRadius:
                                BorderRadius.circular(globalBorderRadius)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor)),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: warningColor)),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor)),
                        hintText: ln.getString(ConstString.retypePass),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
