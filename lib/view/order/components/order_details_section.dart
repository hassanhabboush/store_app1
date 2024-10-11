import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/order_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class OrderDetailsSection extends StatelessWidget {
  const OrderDetailsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslateStringService>(
      builder: (context, ln, child) => Consumer<OrderService>(
        builder: (context, op, child) {
          var meta;
          if (op.orderDetails != null) {
            meta = jsonDecode(op.orderDetails?.data.paymentMeta);
          }

          return meta != null
              ? Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            titleCommon(ln.getString(ConstString.orderDetails)),
                            const SizedBox(
                              height: 25,
                            ),
                            //Service row

                            // bRow('Date', op.orderDetails.data.),

                            bRow(ConstString.subtotal,
                                showWithCurrency(context, meta['subtotal'])),

                            bRow(
                                ConstString.couponDiscount,
                                showWithCurrency(
                                    context, meta['coupon_discounted'] ?? '0')),

                            bRow(ConstString.tax,
                                showWithCurrency(context, meta['product_tax'])),

                            bRow(
                                ConstString.shippingCost,
                                showWithCurrency(
                                    context, meta['shipping_cost'])),

                            bRow(ConstString.paymentMethod,
                                "${op.orderDetails?.data.paymentGateway}"),

                            bRow(
                                ConstString.total,
                                showWithCurrency(context,
                                    op.orderDetails?.data.totalAmount)),
                          ]),
                    ),
                  ],
                )
              : Container();
        },
      ),
    );
  }
}
