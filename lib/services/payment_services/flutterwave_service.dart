// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:flutterwave_standard/models/subaccount.dart';
import 'package:store_app/services/cart_services/cart_service.dart';
import 'package:store_app/services/payment_services/payment_gateway_list_service.dart';
import 'package:store_app/services/place_order_service.dart';
import 'package:store_app/services/profile_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:provider/provider.dart';

import 'package:uuid/uuid.dart';

class FlutterwaveService {
  String currency = 'USD';

  payByFlutterwave(BuildContext context) {
    _handlePaymentInitialization(context);
  }

  _handlePaymentInitialization(BuildContext context) async {
    String amount = Provider.of<CartService>(context, listen: false)
        .totalPrice
        .toStringAsFixed(2);
    String name;
    String phone;
    String email;

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
    // String publicKey = 'FLWPUBK_TEST-86cce2ec43c63e09a517290a8347fcab-X';
    String publicKey =
        Provider.of<PaymentGatewayListService>(context, listen: false)
                .publicKey ??
            '';

    var ln = Provider.of<TranslateStringService>(context, listen: false);

    final style = FlutterwaveStyle(
      appBarText: ln.getString(ConstString.flutterwavePayment),
      buttonColor: Colors.blue,
      buttonTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      appBarColor: Colors.blue,
      dialogCancelTextStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 17,
      ),
      dialogContinueTextStyle: const TextStyle(
        color: Colors.blue,
        fontSize: 17,
      ),
      mainBackgroundColor: Colors.white,
      mainTextStyle:
          const TextStyle(color: Colors.black, fontSize: 17, letterSpacing: 2),
      dialogBackgroundColor: Colors.white,
      appBarIcon: const Icon(Icons.arrow_back, color: Colors.white),
      buttonText: "${ln.getString(ConstString.pay)} \$ $amount",
      appBarTitleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );

    final Customer customer =
        Customer(name: "FLW Developer", phoneNumber: phone, email: email);

    final subAccounts = [
      SubAccount(
          id: "RS_1A3278129B808CB588B53A14608169AD",
          transactionChargeType: "flat",
          transactionPercentage: 25),
      SubAccount(
          id: "RS_C7C265B8E4B16C2D472475D7F9F4426A",
          transactionChargeType: "flat",
          transactionPercentage: 50)
    ];

    final Flutterwave flutterwave = Flutterwave(
        context: context,
        style: style,
        publicKey: publicKey,
        currency: currency,
        txRef: const Uuid().v1(),
        amount: amount,
        customer: customer,
        subAccounts: subAccounts,
        paymentOptions: "card, payattitude",
        customization: Customization(title: "Test Payment"),
        redirectUrl: "https://www.google.com",
        isTestMode: false);
    var response = await flutterwave.charge();
    if (response.success != false) {
      showLoading(response.status!, context);
      print('flutterwave payment successfull');
      Provider.of<PlaceOrderService>(context, listen: false)
          .makePaymentSuccess(context);
      // print("${response.toJson()}");
    } else {
      //User cancelled the payment
      // showLoading("No Response!");
    }
  }

  Future<void> showLoading(String message, context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }
}
