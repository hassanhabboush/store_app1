// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:store_app/services/cart_services/cart_service.dart';
import 'package:store_app/services/profile_service.dart';
import 'package:store_app/view/payments/mollie_payment.dart';
import 'package:provider/provider.dart';

class MollieService {
  payByMollie(BuildContext context) {
    String name;
    String phone;
    String email;
    String amount = Provider.of<CartService>(context, listen: false)
        .totalPrice
        .toStringAsFixed(2);

    name = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.userDetails
            .name ??
        'test';
    phone = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.userDetails
            .mobile ??
        '111111111';
    email = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.userDetails
            .email ??
        'test@test.com';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => MolliePayment(
          amount: amount,
          name: name,
          phone: phone,
          email: email,
        ),
      ),
    );
  }
}
