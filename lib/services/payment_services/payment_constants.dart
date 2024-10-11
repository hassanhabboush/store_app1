// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:store_app/services/payment_services/billplz_service.dart';
import 'package:store_app/services/payment_services/cashfree_service.dart';
import 'package:store_app/services/payment_services/cinetpay_service.dart';
import 'package:store_app/services/payment_services/flutterwave_service.dart';
import 'package:store_app/services/payment_services/instamojo_service.dart';
import 'package:store_app/services/payment_services/mercado_pago_service.dart';
import 'package:store_app/services/payment_services/midtrans_service.dart';
import 'package:store_app/services/payment_services/mollie_service.dart';
import 'package:store_app/services/payment_services/payfast_service.dart';
import 'package:store_app/services/payment_services/paypal_service.dart';
import 'package:store_app/services/payment_services/paystack_service.dart';
import 'package:store_app/services/payment_services/paytabs_service.dart';
import 'package:store_app/services/payment_services/paytm_service.dart';
import 'package:store_app/services/payment_services/razorpay_service.dart';
import 'package:store_app/services/payment_services/square_service.dart';
import 'package:store_app/services/payment_services/stripe_service.dart';
import 'package:store_app/services/payment_services/zitopay_service.dart';
import 'package:store_app/services/place_order_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

randomOrderId() {
  var rng = Random();
  return rng.nextInt(100).toString();
}

payAction(String method, BuildContext context, String transactionId) {
  //to know method names visit PaymentGatewayListService class where payment
  //methods list are fetching with method name
  var ln = Provider.of<TranslateStringService>(context, listen: false);

  switch (method) {
    case 'paypal':
      makePaymentToGetOrderId(context, () {
        PaypalService().payByPaypal(context);
      });
      break;
    case 'cashfree':
      makePaymentToGetOrderId(context, () {
        CashfreeService().getTokenAndPay(context);
      });
      break;
    case 'flutterwave':
      makePaymentToGetOrderId(context, () {
        FlutterwaveService().payByFlutterwave(context);
      });
      break;
    case 'instamojo':
      makePaymentToGetOrderId(context, () {
        InstamojoService().payByInstamojo(context);
      });
      break;
    case 'marcadopago':
      makePaymentToGetOrderId(context, () {
        MercadoPagoService().payByMercado(context);
      });
      break;
    case 'midtrans':
      makePaymentToGetOrderId(context, () {
        MidtransService().payByMidtrans(context);
      });
      break;
    case 'mollie':
      makePaymentToGetOrderId(context, () {
        MollieService().payByMollie(context);
      });
      break;

    case 'payfast':
      makePaymentToGetOrderId(context, () {
        PayfastService().payByPayfast(context);
      });
      break;

    case 'paystack':
      makePaymentToGetOrderId(context, () {
        PaystackService().payByPaystack(context);
      });

      break;
    case 'paytm':
      makePaymentToGetOrderId(context, () {
        PaytmService().payByPaytm(context);
      }, paytmPaymentSelected: true);
      break;

    case 'razorpay':
      makePaymentToGetOrderId(context, () {
        RazorpayService().payByRazorpay(context);
      });
      break;
    case 'stripe':
      makePaymentToGetOrderId(context, () {
        StripeService().makePayment(context);
      });
      break;

    case 'squareup':
      makePaymentToGetOrderId(context, () {
        SquareService().payBySquare(context);
      });
      break;

    case 'cinetpay':
      makePaymentToGetOrderId(context, () {
        CinetPayService().payByCinetpay(context);
      });
      break;

    case 'paytabs':
      makePaymentToGetOrderId(context, () {
        PaytabsService().payByPaytabs(context);
      });
      break;

    case 'billplz':
      makePaymentToGetOrderId(context, () {
        BillPlzService().payByBillPlz(context);
      });
      break;

    case 'zitopay':
      makePaymentToGetOrderId(context, () {
        ZitopayService().payByZitopay(context);
      });
      break;

    case 'manual_payment':
      if (transactionId.trim().isEmpty) {
        showToast(ln.getString(ConstString.youMustUploadCheque), Colors.black);
      } else {
        Provider.of<PlaceOrderService>(context, listen: false).placeOrder(
            context, transactionId,
            isManualOrCod: true, transactionId: transactionId);
      }
      // StripeService().makePayment(context);
      break;
    case 'cash_on_delivery':
      Provider.of<PlaceOrderService>(context, listen: false)
          .placeOrder(context, null, isManualOrCod: true);
      break;
    default:
      {
        debugPrint('not method found');
      }
  }
}

makePaymentToGetOrderId(BuildContext context, VoidCallback function,
    {bool paytmPaymentSelected = false}) async {
  var res = await Provider.of<PlaceOrderService>(context, listen: false)
      .placeOrder(context, null);

  if (res == true) {
    function();
  } else {
    print('order place unsuccessfull, visit payment_constants.dart file');
  }
}
