// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_app/services/payment_services/payment_gateway_list_service.dart';
import 'package:store_app/services/place_order_service.dart';
import 'package:provider/provider.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class PayTabsPayment extends StatelessWidget {
  PayTabsPayment(
      {Key? key,
      required this.amount,
      required this.name,
      required this.phone,
      required this.email})
      : super(key: key);

  final amount;
  final name;
  final phone;
  final email;

  String? url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Text('Paytabs'),
      ),
      body: FutureBuilder(
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
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(
                child: Text('Loding failed.'),
              );
            }
            return WebView(
              // onWebViewCreated: ((controller) {
              //   _controller = controller;
              // }),
              onWebResourceError: (error) {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return const AlertDialog(
                        title: Text('Loading failed!'),
                        content: Text('Failed to load payment page.'),
                      );
                    });

                Navigator.pop(context);
              },
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,

              onPageFinished: (value) async {},
              onPageStarted: (value) async {
                if (!value.contains('result')) {
                  return;
                }
                bool paySuccess = await verifyPayment(value);

                if (paySuccess) {
                  await Provider.of<PlaceOrderService>(context, listen: false)
                      .makePaymentSuccess(context);
                  return;
                }
                await showDialog(
                    context: context,
                    builder: (ctx) {
                      return const AlertDialog(
                        title: Text('Payment failed!'),
                        content: Text('Payment has failed.'),
                      );
                    });

                Navigator.pop(context);
              },
              navigationDelegate: (navRequest) async {
                return NavigationDecision.navigate;
              },
            );
          }),
    );
  }

  waitForIt(BuildContext context) async {
    String orderId =
        Provider.of<PlaceOrderService>(context, listen: false).orderId;

    // String profileId =
    //     Provider.of<PaymentGatewayListService>(context, listen: false)
    //         .paytabProfileId;
    String secretKey =
        Provider.of<PaymentGatewayListService>(context, listen: false)
            .secretKey;

    print('here');
    final url = Uri.parse('https://secure-global.paytabs.com/payment/request');
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": secretKey,
      // Above is API server key for the Midtrans account, encoded to base64
    };

    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "profile_id": 96698,
          "tran_type": "sale",
          "tran_class": "ecom",
          "cart_id": orderId.toString(),
          "cart_description": "Qixer payment",
          "cart_currency": "USD",
          "cart_amount": amount,
        }));
    print(response.body);
    if (response.statusCode == 200) {
      this.url = jsonDecode(response.body)['redirect_url'];
      print(this.url);
      return;
    }

    return true;
  }

  Future<bool> verifyPayment(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body.contains('successful'));
    return response.body.contains('successful');
  }
}
