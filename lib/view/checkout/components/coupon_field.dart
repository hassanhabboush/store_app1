// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:store_app/services/cart_services/coupon_service.dart';
import 'package:store_app/services/cart_services/delivery_address_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/custom_input.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import '../../utils/common_helper.dart';

class CouponField extends StatelessWidget {
  const CouponField(
      {Key? key, required this.cartItemList, required this.couponController})
      : super(key: key);

  final cartItemList;
  final couponController;

  @override
  Widget build(BuildContext context) {
    return Consumer<CouponService>(
      builder: (context, couponProvider, child) =>
          Consumer<TranslateStringService>(
        builder: (context, ln, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapH(20),
            labelCommon(ConstString.couponCode),
            Row(
              children: [
                Expanded(
                    child: CustomInput(
                  hintText: ln.getString(ConstString.enterCouponCode),
                  paddingHorizontal: 20,
                  controller: couponController,
                  marginBottom: 0,
                )),
                Consumer<DeliveryAddressService>(
                    builder: (context, dProvider, child) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 100,
                    child: buttonPrimary(
                        ConstString.apply,
                        dProvider.isLoading
                            ? () {}
                            : () {
                                if (couponController.text.isEmpty) {
                                  showToast(
                                      ln.getString(
                                          ConstString.plzEnterCouponFirst),
                                      Colors.black);
                                  return;
                                }
                                if (couponProvider.isloading == false) {
                                  couponProvider.getCouponDiscount(cartItemList,
                                      couponController.text, context);
                                }
                              },
                        isloading: couponProvider.isloading,
                        borderRadius: 100,
                        bgColor: dProvider.isLoading ? Colors.black26 : null),
                  );
                })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
