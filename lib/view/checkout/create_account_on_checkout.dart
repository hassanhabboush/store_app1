import 'package:flutter/material.dart';
import 'package:store_app/services/cart_services/delivery_address_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class CreateAccountOnCheckout extends StatefulWidget {
  const CreateAccountOnCheckout({super.key, required this.passController});

  final passController;

  @override
  State<CreateAccountOnCheckout> createState() =>
      _CreateAccountOnCheckoutState();
}

class _CreateAccountOnCheckoutState extends State<CreateAccountOnCheckout> {
  bool createAccount = false;

  late bool _newpasswordVisible;

  @override
  void initState() {
    super.initState();
    _newpasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryAddressService>(
      builder: (context, dProvider, child) => Consumer<TranslateStringService>(
        builder: (context, ln, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              checkColor: Colors.white,
              activeColor: primaryColor,
              contentPadding: EdgeInsets.zero,
              title: Text(
                ln.getString(ConstString.createAccountWithTheseDetails),
                style: const TextStyle(
                    color: greyFour, fontWeight: FontWeight.w400, fontSize: 14),
              ),
              value: createAccount,
              onChanged: (newValue) {
                setState(() {
                  createAccount = !createAccount;
                });

                dProvider.setCreateAccountStatus(createAccount);
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            if (createAccount)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gapH(5),

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
                      ))
                ],
              )
          ],
        ),
      ),
    );
  }
}
