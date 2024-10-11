// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:store_app/services/cart_services/cart_service.dart';
import 'package:store_app/services/payment_services/payment_gateway_list_service.dart';
import 'package:store_app/view/payments/zitopay_payment_page.dart';
import 'package:provider/provider.dart';

class ZitopayService {
  payByZitopay(BuildContext context) {
    String amount = Provider.of<CartService>(context, listen: false)
        .totalPrice
        .toStringAsFixed(2);

    var userName =
        Provider.of<PaymentGatewayListService>(context, listen: false)
            .zitopayUserName;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ZitopayPaymentPage(
          amount: amount,
          userName: userName,
        ),
      ),
    );
  }
}
