import 'package:flutter/material.dart';
import 'package:store_app/services/auth_services/reset_password_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';

import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key, required this.email}) : super(key: key);

  final email;

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late bool _newpasswordVisible;
  late bool _repeatnewpasswordVisible;

  @override
  void initState() {
    super.initState();
    _newpasswordVisible = false;
    _repeatnewpasswordVisible = false;
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repeatNewPasswordController = TextEditingController();

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
          physics: globalPhysics,
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
                        titleCommon(ln.getString(ConstString.enterNewPass)),
                        const SizedBox(
                          height: 13,
                        ),
                        paragraphCommon(ConstString.newPassShouldBeDifferent,
                            textAlign: TextAlign.start),

                        const SizedBox(
                          height: 33,
                        ),

                        //New password =========================>
                        labelCommon(ln.getString(ConstString.enterNewPass)),

                        Container(
                            margin: const EdgeInsets.only(bottom: 19),
                            child: TextFormField(
                              controller: newPasswordController,
                              textInputAction: TextInputAction.next,
                              obscureText: !_newpasswordVisible,
                              style: const TextStyle(fontSize: 14),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ln
                                      .getString(ConstString.plzEnterYourPass);
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 22.0,
                                        width: 40.0,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/icons/lock.png'),
                                              fit: BoxFit.fitHeight),
                                        ),
                                      ),
                                    ],
                                  ),
                                  suffixIcon: IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _newpasswordVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _newpasswordVisible =
                                            !_newpasswordVisible;
                                      });
                                    },
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: inputFieldBorderColor),
                                      borderRadius: BorderRadius.circular(
                                          globalBorderRadius)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: primaryColor),
                                      borderRadius: BorderRadius.circular(
                                          globalBorderRadius)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          globalBorderRadius),
                                      borderSide: const BorderSide(
                                          color: warningColor)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: primaryColor),
                                      borderRadius: BorderRadius.circular(
                                          globalBorderRadius)),
                                  hintText: ln.getString(ConstString.newPass),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 18)),
                            )),

                        //Repeat New password =========================>
                        labelCommon(ln.getString(ConstString.repeatNewPass)),

                        Container(
                            margin: const EdgeInsets.only(bottom: 19),
                            child: TextFormField(
                              controller: repeatNewPasswordController,
                              textInputAction: TextInputAction.next,
                              obscureText: !_repeatnewpasswordVisible,
                              style: const TextStyle(fontSize: 14),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ln
                                      .getString(ConstString.plzRetypePass);
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 22.0,
                                        width: 40.0,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/icons/lock.png'),
                                              fit: BoxFit.fitHeight),
                                        ),
                                      ),
                                    ],
                                  ),
                                  suffixIcon: IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _repeatnewpasswordVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _repeatnewpasswordVisible =
                                            !_repeatnewpasswordVisible;
                                      });
                                    },
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: inputFieldBorderColor),
                                      borderRadius: BorderRadius.circular(
                                          globalBorderRadius)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: primaryColor),
                                      borderRadius: BorderRadius.circular(
                                          globalBorderRadius)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          globalBorderRadius),
                                      borderSide: const BorderSide(
                                          color: warningColor)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: primaryColor),
                                      borderRadius: BorderRadius.circular(
                                          globalBorderRadius)),
                                  hintText:
                                      ln.getString(ConstString.retypeNewPass),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 18)),
                            )),

                        //Login button ==================>
                        const SizedBox(
                          height: 13,
                        ),
                        Consumer<ResetPasswordService>(
                          builder: (context, provider, child) => buttonPrimary(
                              ConstString.changePass, () {
                            if (provider.isloading == false) {
                              if (_formKey.currentState!.validate()) {
                                provider.resetPassword(
                                    newPasswordController.text,
                                    repeatNewPasswordController.text,
                                    widget.email,
                                    context);
                              }
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute<void>(
                              //     builder: (BuildContext context) =>
                              //         const LoginPage(),
                              //   ),
                              // );
                            }
                          },
                              isloading:
                                  provider.isloading == false ? false : true),
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
