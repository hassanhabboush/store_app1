// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_app/services/cart_services/cart_service.dart';
import 'package:store_app/services/payment_services/payment_gateway_list_service.dart';
import 'package:store_app/services/place_order_service.dart';
import 'package:store_app/services/profile_service.dart';
import 'package:store_app/view/utils/others_helper.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:webview_flutter/webview_flutter.dart';

class MercadopagoPaymentPage extends StatefulWidget {
  const MercadopagoPaymentPage({Key? key}) : super(key: key);

  @override
  State<MercadopagoPaymentPage> createState() => _MercadopagoPaymentPageState();
}

class _MercadopagoPaymentPageState extends State<MercadopagoPaymentPage> {
  @override
  void initState() {
    super.initState();
  }

  late String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: const Text('Mercado pago')),
      body: FutureBuilder(
          future: getPaymentUrl(context),
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
              onWebResourceError: (error) => showDialog(
                  context: context,
                  builder: (ctx) {
                    return const AlertDialog(
                      title: Text('Loading failed!'),
                      content: Text('Failed to load payment page.'),
                      actions: [
                        Spacer(),
                      ],
                    );
                  }),
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (NavigationRequest request) async {
                if (request.url.contains('https://www.google.com/')) {
                  print('payment success');
                  await Provider.of<PlaceOrderService>(context, listen: false)
                      .makePaymentSuccess(context);

                  return NavigationDecision.prevent;
                }
                if (request.url.contains('https://www.facebook.com/')) {
                  print('payment failed');
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

  Future<dynamic> getPaymentUrl(BuildContext context) async {
    dynamic amount = Provider.of<CartService>(context, listen: false)
        .totalPrice
        .toStringAsFixed(2);

    amount = double.parse(amount);

    String mercadoKey =
        Provider.of<PaymentGatewayListService>(context, listen: false)
                .secretKey ??
            '';

    final orderId =
        Provider.of<PlaceOrderService>(context, listen: false).orderId;

    var email = '';
    email = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.userDetails
            .email ??
        'test@test.com';

    var header = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    };

    var data = jsonEncode({
      "items": [
        {
          "title": "Qixer",
          "description": "Qixer payment",
          "quantity": 1,
          "currency_id": "ARS",
          "unit_price": amount
        }
      ],
      'back_urls': {
        "success": 'https://www.google.com/',
        "failure": 'https://www.facebook.com',
        "pending": 'https://www.facebook.com'
      },
      'auto_return': 'approved',
      "payer": {"email": email}
    });

    var response = await http.post(
        Uri.parse(
            'https://api.mercadopago.com/checkout/preferences?access_token=$mercadoKey'),
        headers: header,
        body: data);

    print(response.body);

    // print(response.body);
    if (response.statusCode == 201) {
      url = jsonDecode(response.body)['init_point'];

      return;
    }
    return '';
  }
}
