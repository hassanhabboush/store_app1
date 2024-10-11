import 'package:flutter/material.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/services/auth_services/change_pass_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late bool _newpasswordVisible;
  late bool _repeatnewpasswordVisible;
  late bool _oldpasswordVisible;

  @override
  void initState() {
    super.initState();
    _newpasswordVisible = false;
    _repeatnewpasswordVisible = false;
    _oldpasswordVisible = false;
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController repeatNewPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();

  bool keepLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarCommon(ConstString.changePass, context, () {
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
                        //New password =========================>
                        labelCommon(ln.getString(ConstString.enterCurrentPass)),

                        Container(
                            margin: const EdgeInsets.only(bottom: 19),
                            decoration: BoxDecoration(
                                // color: const Color(0xfff2f2f2),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextFormField(
                              controller: currentPasswordController,
                              textInputAction: TextInputAction.next,
                              obscureText: !_oldpasswordVisible,
                              style: const TextStyle(fontSize: 14),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ln.getString(
                                      ConstString.enterYourCurrentPass);
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
                                      _oldpasswordVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _oldpasswordVisible =
                                            !_oldpasswordVisible;
                                      });
                                    },
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: greyFive),
                                      borderRadius: BorderRadius.circular(9)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primaryColor)),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: warningColor)),
                                  focusedErrorBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primaryColor)),
                                  hintText: ln
                                      .getString(ConstString.enterCurrentPass),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 18)),
                            )),

                        //New password =========================>
                        labelCommon(ln.getString(ConstString.enterNewPass)),

                        Container(
                            margin: const EdgeInsets.only(bottom: 19),
                            decoration: BoxDecoration(
                                // color: const Color(0xfff2f2f2),
                                borderRadius: BorderRadius.circular(10)),
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
                                      borderSide:
                                          const BorderSide(color: greyFive),
                                      borderRadius: BorderRadius.circular(9)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primaryColor)),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: warningColor)),
                                  focusedErrorBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primaryColor)),
                                  hintText: ln.getString(ConstString.newPass),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 18)),
                            )),

                        //Repeat New password =========================>
                        labelCommon(ln.getString(ConstString.repeatNewPass)),

                        Container(
                            margin: const EdgeInsets.only(bottom: 19),
                            decoration: BoxDecoration(
                                // color: const Color(0xfff2f2f2),
                                borderRadius: BorderRadius.circular(10)),
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
                                      borderSide:
                                          const BorderSide(color: greyFive),
                                      borderRadius: BorderRadius.circular(9)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primaryColor)),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: warningColor)),
                                  focusedErrorBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primaryColor)),
                                  hintText:
                                      ln.getString(ConstString.retypeNewPass),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 18)),
                            )),

                        //Login button ==================>
                        const SizedBox(
                          height: 13,
                        ),
                        Consumer<ChangePassService>(
                          builder: (context, provider, child) => buttonPrimary(
                              ln.getString(ConstString.changePass), () {
                            if (newPasswordController.text.trim().length < 6 ||
                                currentPasswordController.text.trim().length <
                                    6 ||
                                repeatNewPasswordController.text.trim().length <
                                    6) {
                              showToast(ln.getString(ConstString.passMustBeSix),
                                  Colors.black);
                              return;
                            }

                            if (provider.isloading == false) {
                              provider.changePassword(
                                  currentPasswordController.text,
                                  newPasswordController.text,
                                  repeatNewPasswordController.text,
                                  context);
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
