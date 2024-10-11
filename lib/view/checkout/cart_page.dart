import 'package:flutter/material.dart';
import 'package:store_app/services/cart_services/cart_service.dart';
import 'package:store_app/services/cart_services/delivery_address_service.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/checkout/components/cart_products.dart';
import 'package:store_app/view/checkout/components/coupon_field.dart';
import 'package:store_app/view/checkout/components/shipping_select.dart';
import 'package:store_app/view/order/payment_choose_page.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:store_app/view/utils/responsive.dart';
import 'package:provider/provider.dart';

import 'cart_page_skeleton.dart';

class Cartpage extends StatefulWidget {
  const Cartpage({Key? key}) : super(key: key);

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  @override
  void initState() {
    super.initState();
    Provider.of<CartService>(context, listen: false).fetchCartProducts(context);
    Provider.of<CartService>(context, listen: false).resetCoupon(context);
  }

  TextEditingController couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appbarCommon(ConstString.cart, context, () {
          Navigator.pop(context);
        }, hasBackButton: true),
        body: SafeArea(
          child: Listener(
            onPointerDown: (_) {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.focusedChild?.unfocus();
              }
            },
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenPadHorizontal),
                      child: Consumer<CartService>(
                        builder: (context, cProvider, child) => cProvider
                                .cartItemList.isNotEmpty
                            ? Consumer<DeliveryAddressService>(
                                builder: (context, dProvider, child) =>
                                    Consumer<TranslateStringService>(
                                  builder: (context, ln, child) =>
                                      Column(children: [
                                    //Products
                                    //==========>
                                    gapH(13),
                                    const CartProducts(),

                                    // Calculations
                                    // ========>
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 70, bottom: 18),
                                      child: dividerCommon(),
                                    ),
                                    if (dProvider.isLoading)
                                      const CartPageSkeleton(),
                                    if (!dProvider.isLoading)
                                      Column(
                                        children: [
                                          detailsRow(
                                              ConstString.subtotal,
                                              0,
                                              showWithCurrency(
                                                  context, cProvider.subTotal)),
                                          gapH(15),
                                          detailsRow(
                                              ConstString.discount,
                                              0,
                                              showWithCurrency(context,
                                                  cProvider.couponDiscount)),
                                          gapH(15),
                                          detailsRow(
                                              ConstString.tax,
                                              0,
                                              showWithCurrency(context,
                                                  '${dProvider.pTax}')),
                                          gapH(15),
                                          detailsRow(
                                              ConstString.shipping,
                                              0,
                                              showWithCurrency(
                                                  context,
                                                  (dProvider.selectedShipCost +
                                                      (dProvider
                                                              .shippingCostDetails
                                                              ?.tax ??
                                                          0)))),

                                          gapH(15),

                                          //shipping select
                                          const ShippingSelect(),

                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: dividerCommon(),
                                          ),

                                          //Total price
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              titleCommon(
                                                  ln.getString(
                                                      ConstString.total),
                                                  fontsize: 14),
                                              titleCommon(
                                                  showWithCurrency(
                                                      context,
                                                      cProvider.totalPrice
                                                          .toStringAsFixed(2)),
                                                  fontsize: 18)
                                            ],
                                          ),
                                        ],
                                      ),

                                    //Apply promo ===========>
                                    CouponField(
                                      cartItemList: cProvider.cartItemList,
                                      couponController: couponController,
                                    ),

                                    gapH(25),
                                    buttonPrimary(
                                        ConstString.checkout,
                                        dProvider.isLoading
                                            ? () {}
                                            : () {
                                                if (dProvider
                                                    .enteredDeliveryAddress
                                                    .isEmpty) {
                                                  showToast(
                                                      ConstString
                                                          .plzEnterDeliveryAndSave,
                                                      Colors.black);
                                                  return;
                                                }
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute<void>(
                                                    builder: (BuildContext
                                                            context) =>
                                                        const PaymentChoosePage(),
                                                  ),
                                                );
                                              },
                                        borderRadius: 100,
                                        bgColor: dProvider.isLoading
                                            ? Colors.black26
                                            : null),

                                    gapH(30)
                                  ]),
                                ),
                              )
                            : Container(
                                alignment: Alignment.center,
                                height: getScreenHeight(context) - 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: getScreenHeight(context) / 3,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/empty-basket.png'),
                                        ),
                                      ),
                                    ),
                                    titleCommon(
                                        tsProvider?.getString(
                                                ConstString.emptyCart) ??
                                            ConstString.emptyCart,
                                        fontweight: FontWeight.w600,
                                        fontsize: 23),
                                    gapH(10),
                                    paragraphCommon(tsProvider?.getString(
                                            ConstString
                                                .nothingInCartAddFromStore) ??
                                        ConstString.nothingInCartAddFromStore)
                                  ],
                                ),
                              ),
                      )),
                ),
                // Consumer<DeliveryAddressService>(builder: (context, da, child) {
                //   return da.isLoading
                //       ? Positioned.fill(
                //           child: Container(
                //               color: Colors.white,
                //               child: Center(
                //                 child: showLoading(primaryColor),
                //               )))
                //       : const SizedBox();
                // })
              ],
            ),
          ),
        ));
  }
}
