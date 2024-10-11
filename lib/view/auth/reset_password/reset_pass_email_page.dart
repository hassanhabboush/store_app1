import 'package:flutter/material.dart';
import 'package:store_app/services/auth_services/reset_password_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/custom_input.dart';

import 'package:provider/provider.dart';

class ResetPassEmailPage extends StatefulWidget {
  const ResetPassEmailPage({Key? key}) : super(key: key);

  @override
  _ResetPassEmailPageState createState() => _ResetPassEmailPageState();
}

class _ResetPassEmailPageState extends State<ResetPassEmailPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  bool keepLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarCommon(ConstString.resetPass, context, () {
        Navigator.pop(context);
      }),
      backgroundColor: Colors.white,
      body: Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Consumer<TranslateStringService>(
            builder: (context, ln, child) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              height: MediaQuery.of(context).size.height - 120,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 33,
                        ),
                        Text(
                          ln.getString(ConstString.resetPass),
                          style: const TextStyle(
                              color: greyPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        paragraphCommon(
                            ln.getString(
                                ConstString.enterEmailToGetInstruction),
                            textAlign: TextAlign.start),

                        const SizedBox(
                          height: 33,
                        ),

                        //Name ============>
                        labelCommon(ln.getString(ConstString.enterEmail)),

                        CustomInput(
                          controller: emailController,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return ln
                                  .getString(ConstString.plzEnterYourEmail);
                            }
                            return null;
                          },
                          hintText: ln.getString(ConstString.email),
                          icon: 'assets/icons/email.png',
                          textInputAction: TextInputAction.next,
                        ),

                        //Login button ==================>
                        const SizedBox(
                          height: 13,
                        ),
                        Consumer<ResetPasswordService>(
                          builder: (context, provider, child) => buttonPrimary(
                              ConstString.sendInstruction, () {
                            if (provider.isloading == false) {
                              if (_formKey.currentState!.validate()) {
                                provider.sendOtp(
                                    emailController.text.trim(), context);
                              }
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute<void>(
                              //     builder: (BuildContext context) =>
                              //         ResetPassOtpPage(
                              //       email: emailController.text,
                              //     ),
                              //   ),
                              // );
                            }
                          },
                              isloading:
                                  provider.isloading == false ? false : true,
                              borderRadius: 100),
                        ),

                        const SizedBox(
                          height: 30,
                        ),
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
