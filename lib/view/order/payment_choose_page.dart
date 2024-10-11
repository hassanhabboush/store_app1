import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:store_app/services/cart_services/cart_service.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/payment_services/bank_transfer_service.dart';
import 'package:store_app/services/payment_services/payment_constants.dart';
import 'package:store_app/services/payment_services/payment_gateway_list_service.dart';
import 'package:store_app/services/place_order_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/others/terms_condition_page.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/custom_input.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class PaymentChoosePage extends StatefulWidget {
  const PaymentChoosePage({Key? key}) : super(key: key);

  @override
  _PaymentChoosePageState createState() => _PaymentChoosePageState();
}

class _PaymentChoosePageState extends State<PaymentChoosePage> {
  @override
  void initState() {
    super.initState();
  }

  bool cashOnDelivery = false;
  int selectedMethod = -1;
  bool termsAgree = false;
  TextEditingController tiController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //fetch payment gateway list
    Provider.of<PaymentGatewayListService>(context, listen: false)
        .fetchGatewayList(context);

    var placeOrderProvider =
        Provider.of<PlaceOrderService>(context, listen: false);
    var ln = Provider.of<TranslateStringService>(context, listen: false);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appbarCommon(ConstString.payment, context, () {
          if (placeOrderProvider.isloading) {
            showSnackBar(context,
                ln.getString(ConstString.plzWaitOrderProcessed), Colors.red);
            return;
          }
          Navigator.pop(context);
        }),
        body: WillPopScope(
          onWillPop: () {
            if (placeOrderProvider.isloading) {
              showSnackBar(context,
                  ln.getString(ConstString.plzWaitOrderProcessed), Colors.red);
              return Future.value(false);
            }
            return Future.value(true);
          },
          child: SingleChildScrollView(
            child: Consumer<CartService>(
              builder: (context, cP, child) => Consumer<TranslateStringService>(
                builder: (context, ln, child) => Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenPadHorizontal),
                  child: Consumer<PaymentGatewayListService>(
                    builder: (context, pgProvider, child) => pgProvider
                                .paymentList.isNotEmpty ||
                            pgProvider.cashOnD
                        ? Consumer<PlaceOrderService>(
                            builder: (context, provider, child) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: dividerCommon(),
                                  ),

                                  //total
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      titleCommon(
                                          ln.getString(ConstString.total) +
                                              ' :',
                                          fontsize: 17),
                                      paragraphCommon(
                                          showWithCurrency(
                                              context, cP.totalPrice),
                                          fontweight: FontWeight.w600,
                                          fontsize: 18)
                                    ],
                                  ),

                                  //border
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    child: dividerCommon(),
                                  ),

                                  titleCommon(ln
                                      .getString(ConstString.choosePayMethod)),
                                  if (!cashOnDelivery)
                                    //payment method card
                                    GridView.builder(
                                      gridDelegate:
                                          const FlutterzillaFixedGridView(
                                              crossAxisCount: 3,
                                              mainAxisSpacing: 15,
                                              crossAxisSpacing: 15,
                                              height: 60),
                                      padding: const EdgeInsets.only(top: 30),
                                      itemCount: pgProvider.paymentList.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      clipBehavior: Clip.none,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedMethod = index;
                                            });

                                            pgProvider.setSelectedMethodName(
                                                pgProvider.paymentList[
                                                    selectedMethod]['name']);

                                            //set key
                                            pgProvider.setKey(
                                                pgProvider.paymentList[
                                                    selectedMethod]['name'],
                                                index);
                                          },
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: 60,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: selectedMethod ==
                                                              index
                                                          ? primaryColor
                                                          : borderColor),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: pgProvider
                                                          .paymentList[index]
                                                      ['image'],
                                                  placeholder: (context, url) {
                                                    return Image.asset(
                                                        'assets/images/placeholder.png');
                                                  },
                                                  // fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                              selectedMethod == index
                                                  ? Positioned(
                                                      right: -7,
                                                      top: -9,
                                                      child: checkCircle())
                                                  : Container()
                                            ],
                                          ),
                                        );
                                      },
                                    ),

                                  if (selectedMethod != -1)
                                    pgProvider.paymentList[selectedMethod]
                                                ['name'] ==
                                            'manual_payment'
                                        ?
                                        //pick image ==========>
                                        Consumer<BankTransferService>(
                                            builder: (context, btProvider,
                                                    child) =>
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    //pick image button =====>

                                                    const SizedBox(height: 30),
                                                    labelCommon(
                                                        "Transaction Id"),
                                                    paragraphCommon(
                                                        "CCP: 002487517 / RIP: 15415121541",
                                                        color:
                                                            Colors.blueAccent),
                                                    gapH(8),
                                                    CustomInput(
                                                        controller:
                                                            tiController,
                                                        hintText:
                                                            "Enter transaction id"),

                                                    // btProvider.pickedImage !=
                                                    //         null
                                                    //     ? Column(
                                                    //         children: [
                                                    //           const SizedBox(
                                                    //             height: 30,
                                                    //           ),
                                                    //           SizedBox(
                                                    //             height: 80,
                                                    //             child:
                                                    //                 ListView(
                                                    //               clipBehavior:
                                                    //                   Clip.none,
                                                    //               scrollDirection:
                                                    //                   Axis.horizontal,
                                                    //               shrinkWrap:
                                                    //                   true,
                                                    //               children: [
                                                    //                 InkWell(
                                                    //                   onTap:
                                                    //                       () {},
                                                    //                   child:
                                                    //                       Column(
                                                    //                     children: [
                                                    //                       Container(
                                                    //                         margin: const EdgeInsets.only(right: 10),
                                                    //                         child: Image.file(
                                                    //                           File(btProvider.pickedImage.path),
                                                    //                           height: 80,
                                                    //                           width: 80,
                                                    //                           fit: BoxFit.cover,
                                                    //                         ),
                                                    //                       ),
                                                    //                     ],
                                                    //                   ),
                                                    //                 ),
                                                    //               ],
                                                    //             ),
                                                    //           ),
                                                    //         ],
                                                    //       )
                                                    //     : Container(),
                                                  ],
                                                ))
                                        : Container(),

                                  //Agreement checkbox ===========>
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  if (pgProvider.cashOnD)
                                    SizedBox(
                                      // width: 55,
                                      child: CheckboxListTile(
                                        checkColor: Colors.white,
                                        activeColor: primaryColor,
                                        contentPadding: const EdgeInsets.all(0),
                                        value: cashOnDelivery,
                                        onChanged: (newValue) {
                                          setState(() {
                                            cashOnDelivery = !cashOnDelivery;
                                            selectedMethod = -1;
                                          });
                                          if (cashOnDelivery) {
                                            pgProvider.setSelectedMethodName(
                                                "cash_on_delivery");
                                          }
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        title: paragraphCommon(
                                            ln.getString(
                                                ConstString.cashOnDelivery),
                                            textAlign: TextAlign.start),
                                      ),
                                    ),
                                  if (pgProvider.cashOnD) gapH(8),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 55,
                                        child: CheckboxListTile(
                                          checkColor: Colors.white,
                                          activeColor: primaryColor,
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          value: termsAgree,
                                          onChanged: (newValue) {
                                            setState(() {
                                              termsAgree = !termsAgree;
                                            });
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          paragraphCommon(ln.getString(
                                              ConstString.iAgreeTerms)),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const TermsConditionPage()));
                                            },
                                            child: paragraphCommon(
                                                '(${ln.getString(ConstString.clickToSee)})',
                                                fontweight: FontWeight.w600,
                                                color: Colors.blue),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),

                                  //pay button =============>
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  buttonPrimary(ConstString.payConfirmOrder,
                                      () {
                                    if (termsAgree == false) {
                                      showToast(
                                          ln.getString(
                                              ConstString.youMustAgreeTerms),
                                          Colors.black);

                                      return;
                                    }
                                    if (!cashOnDelivery && selectedMethod < 0) {
                                      showToast(
                                          ConstString
                                              .youMustSelectAPaymentMethod,
                                          Colors.black);
                                      return;
                                    }
                                    if (provider.isloading == true) {
                                      return;
                                    }

                                    payAction(
                                        cashOnDelivery
                                            ? "cash_on_delivery"
                                            : pgProvider
                                                    .paymentList[selectedMethod]
                                                ['name'],
                                        context,
                                        //if user selected bank transfer
                                        tiController.text);
                                  },
                                      isloading: provider.isloading == false
                                          ? false
                                          : true),

                                  const SizedBox(
                                    height: 30,
                                  )
                                ]),
                          )
                        : Container(
                            margin: const EdgeInsets.only(top: 60),
                            child: showLoading(primaryColor),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
