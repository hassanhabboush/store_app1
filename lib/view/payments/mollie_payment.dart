// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_app/services/payment_services/payment_gateway_list_service.dart';
import 'package:store_app/services/place_order_service.dart';
import 'package:provider/provider.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class MolliePayment extends StatelessWidget {
  MolliePayment(
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
  String? statusURl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Text('Mollie'),
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
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageStarted: (value) async {
                var redirectUrl =
                    Provider.of<PlaceOrderService>(context, listen: false)
                        .successUrl;

                if (value.contains(redirectUrl)) {
                  String status = await verifyPayment(context);
                  if (status == 'paid') {
                    await Provider.of<PlaceOrderService>(context, listen: false)
                        .makePaymentSuccess(context);
                  }
                  if (status == 'open') {
                    await showDialog(
                        context: context,
                        builder: (ctx) {
                          return const AlertDialog(
                            title: Text('Payment cancelled!'),
                            content: Text('Payment has been cancelled.'),
                          );
                        });
                    Navigator.pop(context);
                  }
                  if (status == 'failed') {
                    await showDialog(
                        context: context,
                        builder: (ctx) {
                          return const AlertDialog(
                            title: Text('Payment failed!'),
                          );
                        });
                    Navigator.pop(context);
                  }
                  if (status == 'expired') {
                    await showDialog(
                        context: context,
                        builder: (ctx) {
                          return const AlertDialog(
                            title: Text('Payment failed!'),
                            content: Text('Payment has been expired.'),
                          );
                        });
                    Navigator.pop(context);
                  }
                }
              },
            );
          }),
    );
  }

  waitForIt(BuildContext context) async {
    final publicKey =
        Provider.of<PaymentGatewayListService>(context, listen: false)
            .publicKey;

    // final publicKey = 'test_fVk76gNbAp6ryrtRjfAVvzjxSHxC2v';

    String orderId =
        Provider.of<PlaceOrderService>(context, listen: false).orderId;
    // Provider.of<PlaceOrderService>(context, listen: false).orderId;

    final url = Uri.parse('https://api.mollie.com/v2/payments');
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $publicKey",
      // Above is API server key for the Midtrans account, encoded to base64
    };

    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "amount": {"value": amount, "currency": "USD"},
          "description": "Qixer payment",
          "redirectUrl":
              Provider.of<PlaceOrderService>(context, listen: false).successUrl,
          "webhookUrl":
              Provider.of<PlaceOrderService>(context, listen: false).successUrl,
          "metadata": 'mollieQixer$orderId',
          // "method": "creditcard",
        }));
    if (response.statusCode == 201) {
      this.url = jsonDecode(response.body)['_links']['checkout']['href'];
      print('url link is ${this.url}');
      statusURl = jsonDecode(response.body)['_links']['self']['href'];
      print(statusURl);
      return;
    } else {
      print(response.body);
    }

    return true;
  }

  verifyPayment(BuildContext context) async {
    final publicKey =
        Provider.of<PaymentGatewayListService>(context, listen: false)
            .publicKey;

    // final publicKey = 'test_fVk76gNbAp6ryrtRjfAVvzjxSHxC2v';

    final url = Uri.parse(statusURl as String);
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $publicKey",
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final response = await http.get(url, headers: header);
    print(jsonDecode(response.body)['status']);
    return jsonDecode(response.body)['status'];
  }
}
