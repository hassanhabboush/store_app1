import 'package:flutter/material.dart';
import 'package:store_app/services/cart_services/cart_service.dart';
import 'package:store_app/services/profile_service.dart';
import 'package:store_app/view/payments/instamojo_payment_page.dart';
import 'package:provider/provider.dart';

class InstamojoService {
  payByInstamojo(BuildContext context) {
    String amount = Provider.of<CartService>(context, listen: false)
        .totalPrice
        .toStringAsFixed(2);

    String name;
    String email;

    name = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.userDetails
            .name ??
        'test';

    email = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.userDetails
            .email ??
        'test@test.com';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => InstamojoPaymentPage(
          amount: amount,
          name: name,
          email: email,
        ),
      ),
    );
  }
}
