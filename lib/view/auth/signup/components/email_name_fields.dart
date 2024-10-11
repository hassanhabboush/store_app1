// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:store_app/services/auth_services/signup_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/custom_input.dart';
import 'package:provider/provider.dart';

class EmailNameFields extends StatelessWidget {
  const EmailNameFields({
    Key? key,
    required this.fullNameController,
    required this.userNameController,
    required this.emailController,
  }) : super(key: key);

  final fullNameController;
  final userNameController;
  final emailController;

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslateStringService>(
      builder: (context, ln, child) => Consumer<SignupService>(
        builder: (context, provider, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Name ============>
            labelCommon(ConstString.fullName),

            CustomInput(
              controller: fullNameController,
              paddingHorizontal: 20,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return ln.getString(ConstString.plzEnterFullName);
                }
                return null;
              },
              hintText: ln.getString(ConstString.enterFullName),
              textInputAction: TextInputAction.next,
            ),

            //User name ============>
            labelCommon(ConstString.userName),

            CustomInput(
              controller: userNameController,
              paddingHorizontal: 20,
              marginBottom: 5,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return ln.getString(ConstString.plzEnterUsername);
                }
                return null;
              },
              hintText: ln.getString(ConstString.enterUsername),
              textInputAction: TextInputAction.next,
              onChanged: (v) {
                provider.checkUsername(v, context);
              },
            ),

            if (provider.usernameData != null)
              paragraphCommon(provider.usernameData, color: successColor),

            //Email ============>

            gapH(16),
            labelCommon(ConstString.email),

            CustomInput(
              controller: emailController,
              paddingHorizontal: 20,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return ln.getString(ConstString.plzEnterYourEmail);
                }
                return null;
              },
              hintText: ConstString.enterEmail,
              textInputAction: TextInputAction.next,
            ),
          ],
        ),
      ),
    );
  }
}
