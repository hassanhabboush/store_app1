// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_app/services/payment_services/payment_gateway_list_service.dart';
import 'package:store_app/services/place_order_service.dart';
import 'package:store_app/view/utils/others_helper.dart';

import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class BillplzPayment extends StatelessWidget {
  BillplzPayment(
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
  late WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Text('BillPlz'),
      ),
      body: FutureBuilder(
          future: waitForIt(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
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
              onWebResourceError: (error) => showDialog(
                  context: context,
                  builder: (ctx) {
                    return const AlertDialog(
                      title: Text('Loading failed!'),
                      content: Text('Failed to load payment page.'),
                    );
                  }),
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (value) async {
                debugPrint(
                    "$value.............................................."
                        .toString());
                // verifyPayment(value, context);
              },
              navigationDelegate: (navigation) {
                if (navigation.url.contains("paid%5D=true") &&
                    navigation.url.contains("http://www.xgenious.com")) {
                  Provider.of<PlaceOrderService>(context, listen: false)
                      .makePaymentSuccess(context);
                  return NavigationDecision.prevent;
                }
                if (navigation.url.contains("paid%5D=false") &&
                    navigation.url.contains("http://www.xgenious.com")) {
                  showSnackBar(context, 'Payment failed', Colors.red);
                  Navigator.pop(context);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            );
          }),
    );
  }

  JavascriptChannel _extractDataJSChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Flutter',
      onMessageReceived: (JavascriptMessage message) {
        String pageBody = message.message;
        print('page body: $pageBody');
      },
    );
  }

  waitForIt(BuildContext context) async {
    // String orderId =
    //     Provider.of<PlaceOrderService>(context, listen: false).orderId;

    final url = Uri.parse('https://www.billplz-sandbox.com/api/v3/bills');
    final username =
        Provider.of<PaymentGatewayListService>(context, listen: false)
                .publicKey ??
            '';

    final collectionName =
        Provider.of<PaymentGatewayListService>(context, listen: false)
                .billPlzCollectionName ??
            '';
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$username'))}';
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": basicAuth,
      // Above is API server key for the Midtrans account, encoded to base64
    };
    debugPrint(base64Encode(utf8.encode('$username:$username')).toString());
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "collection_id": collectionName,
          "description": "Qixer payment",
          "email": email,
          "name": name,
          "amount": "${double.parse(amount) * 100}",
          "reference_1_label": "Bank Code",
          "reference_1": "BP-FKR01",
          "redirect_url": "http://www.xgenious.com",
          "callback_url": "http://www.xgenious.com"
        }));
    debugPrint(response.body.toString());
    if (response.statusCode == 200) {
      this.url = jsonDecode(response.body)["url"];
      return;
    }

    return true;
  }
}

// Future verifyPayment(String url, BuildContext context) async {
//   final uri = Uri.parse(url);
//   final response = await http.get(uri);
//   if (response.body.contains('paid')) {
//     Provider.of<PlaceOrderService>(context, listen: false)
//         .makePaymentSuccess(context);

//     return;
//   }
//   if (response.body.contains('your payment was not')) {
//     showSnackBar(context, 'Payment failed', Colors.red);
//     Navigator.pop(context);
//     return;
//   }
// }
