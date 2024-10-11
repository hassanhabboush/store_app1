// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/services/cart_services/cart_service.dart';
import 'package:store_app/services/payment_services/payment_gateway_list_service.dart';
import 'package:store_app/services/place_order_service.dart';
import 'package:store_app/services/profile_service.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StripeService with ChangeNotifier {
  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  Map<String, dynamic>? paymentIntentData;

  displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) async {
        print('stripe payment successfull');
        Provider.of<PlaceOrderService>(context, listen: false)
            .makePaymentSuccess(context);
        // print('payment id' + paymentIntentData!['id'].toString());
        // print('payment client secret' +
        //     paymentIntentData!['client_secret'].toString());
        // print('payment amount' + paymentIntentData!['amount'].toString());
        // print('payment intent full data' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        // showToast("Payment Successful", Colors.black);

        //payment successs ================>

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        debugPrint('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException {
      // print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showToast("Payment cancelled", Colors.red);
    } catch (e) {
      debugPrint('$e');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
    // return amount;
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency, context) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      // var header ={
      //       'Authorization':
      //           'Bearer sk_test_51GwS1SEmGOuJLTMs2vhSliTwAGkOt4fKJMBrxzTXeCJoLrRu8HFf4I0C5QuyE3l3bQHBJm3c0qFmeVjd0V9nFb6Z00VrWDJ9Uw',
      //       'Content-Type': 'application/x-www-form-urlencoded'
      //     };
      var header = {
        'Authorization':
            'Bearer ${Provider.of<PaymentGatewayListService>(context, listen: false).secretKey}',
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      // print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: header);
      // print('Create Intent reponse ===> ${response.body.toString()}');
      // debugPrint("response body is ${response.body}");
      return jsonDecode(response.body);
    } catch (err) {
      debugPrint('err charging user: ${err.toString()}');
    }
  }

  Future<void> makePayment(BuildContext context) async {
    var name;
    name = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.userDetails
            .name ??
        'test';

    String amount = Provider.of<CartService>(context, listen: false)
        .totalPrice
        .toStringAsFixed(0);

    //Stripe takes only integer value

    try {
      paymentIntentData = await createPaymentIntent(amount, 'USD', context);
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  // applePay: true,
                  // googlePay: true,
                  // testEnv: true,
                  style: ThemeMode.light,
                  // merchantCountryCode: 'US',
                  merchantDisplayName: name))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet(context);
    } catch (e, s) {
      debugPrint('exception:$e$s');
    }
  }

  //get stripe key ==========>

  Future<String> getStripeKey() async {
    var defaultPublicKey =
        'pk_test_51GwS1SEmGOuJLTMsIeYKFtfAT3o3Fc6IOC7wyFmmxA2FIFQ3ZigJ2z1s4ZOweKQKlhaQr1blTH9y6HR2PMjtq1Rx00vqE8LO0x';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      "x-api-key": xApiKey,
      "Authorization": "Bearer $token",
    };

    var response =
        await http.get(Uri.parse(ApiUrl.gatewayListUri), headers: header);
    if (response.statusCode == 201 || response.statusCode == 200) {
      var paymentList = jsonDecode(response.body)['data'];
      var publicKey;

      for (int i = 0; i < paymentList.length; i++) {
        if (paymentList[i]['name'] == 'stripe') {
          publicKey = paymentList[i]['credentials']['public_key'];
        }
      }
      if (publicKey == null) {
        return defaultPublicKey;
      } else {
        return publicKey;
      }
    } else {
      //failed loading
      return defaultPublicKey;
    }
  }
}
