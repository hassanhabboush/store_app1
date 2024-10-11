import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_app/services/cart_services/cart_service.dart';
import 'package:store_app/services/payment_services/payment_gateway_list_service.dart';
import 'package:store_app/services/place_order_service.dart';
import 'package:store_app/services/profile_service.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class PaystackPaymentPage extends StatelessWidget {
  PaystackPaymentPage({Key? key}) : super(key: key);
  String? url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: const Text('Paystack')),
      body: WillPopScope(
        onWillPop: () async {
          await showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text('Are you sure?'),
                  content:
                      const Text('Your payment proccess will be terminated.'),
                  actions: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: primaryColor),
                      ),
                    )
                  ],
                );
              });
          return false;
        },
        child: FutureBuilder(
            future: waitForIt(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                return const Center(
                  child: Text('Loding failed.'),
                );
              }
              // if (snapshot.hasError) {
              //   print(snapshot.error);
              //   return const Center(
              //     child: Text('Loding failed.'),
              //   );
              // }
              return WebView(
                // onWebViewCreated: ((controller) {
                //   _controller = controller;
                // }),
                onWebResourceError: (error) => showDialog(
                    context: context,
                    builder: (ctx) {
                      return const AlertDialog(
                        title: Text('Payment failed!'),
                        content: Text(''),
                        actions: [
                          Spacer(),
                        ],
                      );
                    }),
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (value) async {
                  // final title = await _controller.currentUrl();
                  // print(title);
                  print('on finished.........................$value');
                  final uri = Uri.parse(value);
                  final response = await http.get(uri);
                  // if (response.body.contains('PAYMENT ID')) {

                  if (response.body.contains('Payment Successful')) {
                    Provider.of<PlaceOrderService>(context, listen: false)
                        .makePaymentSuccess(context);

                    return;
                  }
                  if (response.body.contains('Declined')) {
                    await showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text('Payment failed!'),
                            content: const Text('Payment has been cancelled.'),
                            actions: [
                              const Spacer(),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Ok',
                                  style: TextStyle(color: primaryColor),
                                ),
                              )
                            ],
                          );
                        });
                  }
                },
                navigationDelegate: (navRequest) async {
                  print('nav req to .......................${navRequest.url}');
                  if (navRequest.url.contains('success')) {
                    await Provider.of<PlaceOrderService>(context, listen: false)
                        .makePaymentSuccess(context);
                    return NavigationDecision.prevent;
                  }
                  if (navRequest.url.contains('failed')) {
                    Navigator.pop(context);
                  }
                  return NavigationDecision.navigate;
                },
              );
            }),
      ),
    );
  }

  Future<void> waitForIt(BuildContext context) async {
    final uri = Uri.parse('https://api.paystack.co/transaction/initialize');

    final orderId =
        Provider.of<PlaceOrderService>(context, listen: false).orderId;

    var email = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.userDetails
            .email ??
        'test@test.com';
    String paystackSecretKey =
        Provider.of<PaymentGatewayListService>(context, listen: false)
                .secretKey ??
            '';

    dynamic amount;
    amount = Provider.of<CartService>(context, listen: false)
        .totalPrice
        .toStringAsFixed(0);
    amount = int.parse(amount);

    print(orderId);

    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $paystackSecretKey",
      // Above is API server key for the Midtrans account, encoded to base64
    };

    // final orderId = Random().nextInt(23000).toInt();
    final response = await http.post(uri,
        headers: header,
        body: jsonEncode({
          "amount": amount,
          "currency": "NGN",
          "email": email,
          "reference_id": orderId.toString(),
          "callback_url": "http://success.com",
          "metadata": {"cancel_action": "http://failed.com"}
        }));
    print(response.body);
    if (response.statusCode == 200) {
      url = jsonDecode(response.body)['data']['authorization_url'];
      print(url);
      return;
    }

    // print(response.statusCode);
    // if (response.statusCode == 201) {
    // this.url =
    //     'https://sandbox.payfast.co.za/eng/process?merchant_id=${selectedGateaway.merchantId}&merchant_key=${selectedGateaway.merchantKey}&amount=$amount&item_name=GrenmartGroceries';
    // //   return;
    // // }

    // return true;
  }

  Future<bool> verifyPayment(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body.contains('Payment Completed'));
    return response.body.contains('Payment Completed');
  }
}
