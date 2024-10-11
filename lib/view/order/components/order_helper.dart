import 'package:flutter/material.dart';
import 'package:store_app/services/order_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OrderHelper {
  refundPopup(BuildContext context, {required orderId, required productId}) {
    return Alert(
        context: context,
        style: AlertStyle(
            alertElevation: 0,
            overlayColor: Colors.black.withOpacity(.6),
            alertPadding: const EdgeInsets.all(25),
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
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
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
            builder: (context, ln, child) => Column(
              children: [
                Text(
                  '${ln.getString(ConstString.areYouSure)}?',
                  style: const TextStyle(color: greyPrimary, fontSize: 17),
                ),
                const SizedBox(
                  height: 25,
                ),
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
                    Consumer<OrderService>(
                      builder: (context, provider, child) => Expanded(
                          child:
                              buttonPrimary(ln.getString(ConstString.yes), () {
                        provider.refundProduct(context,
                            orderId: orderId, productId: productId);
                      }, isloading: provider.refundLoading)),
                    ),
                  ],
                )
              ],
            ),
          ),
        )).show();
  }
}
