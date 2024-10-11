// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:store_app/services/place_order_service.dart';
import 'package:store_app/view/payments/paytm_payment.dart';
import 'package:provider/provider.dart';

class PaytmService {
  payByPaytm(BuildContext context) {
    //========>
    Provider.of<PlaceOrderService>(context, listen: false).setLoadingFalse();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaytmPayment(),
      ),
    );
  }
}
