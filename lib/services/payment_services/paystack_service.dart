import 'package:flutter/material.dart';
import 'package:store_app/services/place_order_service.dart';
import 'package:store_app/view/payments/paystack_payment_page.dart';
import 'package:provider/provider.dart';

class PaystackService {
  payByPaystack(BuildContext context) {
    Provider.of<PlaceOrderService>(context, listen: false).setLoadingFalse();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaystackPaymentPage(),
      ),
    );
  }
}
