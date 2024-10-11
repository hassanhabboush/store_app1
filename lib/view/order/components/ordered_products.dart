import 'package:flutter/material.dart';
import 'package:store_app/services/order_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/order/components/order_helper.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class OrderedProducts extends StatelessWidget {
  const OrderedProducts({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  final orderId;

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslateStringService>(
      builder: (context, ln, child) => Consumer<OrderService>(
        builder: (context, os, child) => Container(
          margin: const EdgeInsets.only(bottom: 25),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(9)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleCommon(ConstString.products),
              const SizedBox(
                height: 20,
              ),
              for (int i = 0; i < os.detailsProductList.length; i++)
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleCommon(os.detailsProductList[i]['name'], fontsize: 15),
                  gapH(2),
                  paragraphCommon(ln.getString(ConstString.quantity) +
                      ': ${os.detailsProductList[i]['qty']}'),
                  gapH(6),
                  SizedBox(
                    width: 150,
                    child: buttonPrimary(ConstString.requestRefund, () {
                      OrderHelper().refundPopup(context,
                          orderId: orderId,
                          productId: os.detailsProductList[i]['id']);
                    }, paddingVertical: 5, borderRadius: 5),
                  ),
                  gapH(12),
                ])
            ],
          ),
        ),
      ),
    );
  }
}
