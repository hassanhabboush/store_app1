import 'package:flutter/material.dart';
import 'package:store_app/services/profile_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/custom_input.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProfileHelper {
  deleteAccountPopup(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passController = TextEditingController();

    return Alert(
        context: context,
        style: AlertStyle(
            alertElevation: 0,
            overlayColor: Colors.black.withOpacity(.6),
            isButtonVisible: false,
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            titleStyle: const TextStyle(),
            animationType: AnimationType.grow,
            animationDuration: const Duration(milliseconds: 500)),
        content: Container(
          margin: const EdgeInsets.only(top: 22),
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  spreadRadius: -2,
                  blurRadius: 13,
                  offset: const Offset(0, 13)),
            ],
          ),
          child: Consumer<TranslateStringService>(
            builder: (context, ln, child) => Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Email ============>
                  labelCommon(ConstString.email),

                  CustomInput(
                    controller: emailController,
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return ln.getString(ConstString.plzEnterEmail);
                      }
                      return null;
                    },
                    hintText: ln.getString(ConstString.enterEmail),
                    paddingHorizontal: 20,
                    textInputAction: TextInputAction.next,
                  ),

                  //Email ============>
                  labelCommon(ConstString.pass),

                  CustomInput(
                    controller: passController,
                    isPasswordField: true,
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return ln.getString(ConstString.plzEnterPass);
                      }
                      return null;
                    },
                    hintText: ln.getString(ConstString.enterPass),
                    paddingHorizontal: 20,
                    textInputAction: TextInputAction.next,
                  ),

                  gapH(10),

                  Row(
                    children: [
                      Expanded(
                          child: borderButtonPrimary(
                              ln.getString(ConstString.cancel), () {
                        Navigator.pop(context);
                      })),
                      const SizedBox(
                        width: 16,
                      ),
                      Consumer<ProfileService>(
                        builder: (context, provider, child) => Expanded(
                            child: buttonPrimary(
                                ln.getString(ConstString.delete), () {
                          if (provider.isloading == false) {
                            if (formKey.currentState!.validate()) {
                              provider.deleteProfile(context,
                                  email: emailController.text,
                                  pass: passController.text);
                            }
                          }
                        },
                                isloading: provider.isloading == false
                                    ? false
                                    : true)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )).show();
  }
}
