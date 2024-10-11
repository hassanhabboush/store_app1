import 'package:flutter/material.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/order_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/order/components/order_details_section.dart';
import 'package:store_app/view/order/components/ordered_products.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:store_app/view/utils/responsive.dart';
import 'package:provider/provider.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.orderId});

  final orderId;

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderService>(context, listen: false)
        .fetchOrderDetails(context, orderId: orderId);

    return Scaffold(
      appBar: appbarCommon(ConstString.orderDetails, context, (() {
        Navigator.pop(context);
      })),
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Consumer<TranslateStringService>(
          builder: (context, ln, child) => Consumer<OrderService>(
            builder: (context, op, child) => op.orderDetails != null
                ? Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding:
                        EdgeInsets.symmetric(horizontal: screenPadHorizontal),
                    child: Column(children: [
                      //details top
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.15),
                              borderRadius: BorderRadius.circular(7)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      titleCommon(
                                          ln.getString(ConstString.order) +
                                              ' #${op.orderDetails?.data.id}'),
                                      gapH(10),
                                      paragraphCommon(
                                          showWithCurrency(
                                              context,
                                              op.orderDetails?.data
                                                  .totalAmount),
                                          fontsize: 30,
                                          color: primaryColor),
                                    ]),
                              ),

                              //
                              Expanded(
                                  child: Column(
                                children: [
                                  buttonPrimary(
                                      '${ConstString.payment}: ${op.orderDetails?.data.paymentStatus}',
                                      (() {}),
                                      paddingVertical: 10,
                                      bgColor: Colors.green[800]),
                                  gapH(10),
                                  buttonPrimary(
                                      '${ConstString.order}: ${op.orderDetails?.data.status}',
                                      (() {}),
                                      paddingVertical: 10,
                                      bgColor: Colors.yellow[800]),
                                ],
                              ))
                            ],
                          )),

                      //==========>
                      // order details

                      gapH(25),
                      const OrderDetailsSection(),

                      OrderedProducts(
                        orderId: op.orderDetails?.data.id,
                      ),

                      gapH(25),
                    ]),
                  )
                : Container(
                    alignment: Alignment.center,
                    height: getScreenHeight(context) - 150,
                    child: showLoading(primaryColor),
                  ),
          ),
        ),
      ),
    );
  }
}
