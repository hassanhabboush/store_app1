import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/order_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/order/order_details_page.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/responsive.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarCommon(ConstString.myOrders, context, () {
        Navigator.pop(context);
      }),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: () async {
          final result = await Provider.of<OrderService>(context, listen: false)
              .fetchOrderList(context, isrefresh: true);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result = await Provider.of<OrderService>(context, listen: false)
              .fetchOrderList(context);
          if (result) {
            debugPrint('loadcomplete ran');
            //loadcomplete function loads the data again
            refreshController.loadComplete();
          } else {
            debugPrint('no more data');
            refreshController.loadNoData();

            Future.delayed(const Duration(seconds: 1), () {
              //it will reset footer no data state to idle and will let us load again
              refreshController.resetNoData();
            });
          }
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: screenPadHorizontal),
            child: Consumer<TranslateStringService>(
              builder: (context, ln, child) => Consumer<OrderService>(
                builder: (context, op, child) => op.hasOrder == true
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            gapH(15),
                            for (int i = 0; i < op.orderList.length; i++)
                              ExpandablePanel(
                                controller: ExpandableController(
                                    initialExpanded: false),
                                theme:
                                    const ExpandableThemeData(hasIcon: false),
                                header: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 18),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: borderColor),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            capsule(op.orderList[i].status),
                                            const SizedBox(
                                              width: 17,
                                            ),
                                            AutoSizeText(
                                              '#${op.orderList[i].id}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: greyFour,
                                                  // height: 2.2,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  ]),
                                ),
                                collapsed: const Text(''),
                                expanded: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: borderColor),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(
                                        children: [
                                          for (int j = 0;
                                              j < op.productList[i].length;
                                              j++)
                                            //product ===>
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: i != 1 ? 19 : 0),
                                              child: Row(
                                                children: [
                                                  //title image price
                                                  Expanded(
                                                      child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      //title and price
                                                      Flexible(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              op.productList[i]
                                                                  [j]['name'],
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  color:
                                                                      blackCustomColor,
                                                                  fontSize: 13,
                                                                  height: 1.4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),

                                                            //Price and stock
                                                            const SizedBox(
                                                              height: 6,
                                                            ),
                                                            Text(
                                                              showWithCurrency(
                                                                  context,
                                                                  op.productList[
                                                                          i][j][
                                                                      'price']),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  color:
                                                                      primaryColor,
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                                  //Delete button
                                                  Container(
                                                    height: 35,
                                                    width: 35,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: borderColor),
                                                    ),
                                                    child: Text(
                                                      'x${op.productList[i][j]['qty']}',
                                                      style: const TextStyle(
                                                          color: greyParagraph),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          gapH(20),
                                          buttonPrimary(ConstString.details,
                                              (() {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        OrderDetailsPage(
                                                  orderId: op.orderList[i].id,
                                                ),
                                              ),
                                            );
                                          }),
                                              borderRadius: 100,
                                              bgColor: Colors.grey[200],
                                              fontColor: Colors.grey[800])
                                        ],
                                      ),
                                    ),
                                    gapH(20),
                                  ],
                                ),
                              ),
                          ])
                    : Container(
                        height: getScreenHeight(context) - 200,
                        alignment: Alignment.center,
                        child: paragraphCommon('No order found'),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
