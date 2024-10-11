import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_app/model/profile_model.dart';
import 'package:store_app/services/cart_services/cart_service.dart';
import 'package:store_app/services/cart_services/delivery_address_service.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class CartProducts extends StatelessWidget {
  const CartProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartService>(
      builder: (context, cProvider, child) => Column(
        children: [
          for (int i = 0; i < cProvider.cartItemList.length; i++)
            Column(
              children: [
                Row(
                  children: [
                    //title image price
                    Expanded(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        commonImage(
                            cProvider.cartItemList[i]['thumbnail'], 55, 55),

                        const SizedBox(
                          width: 10,
                        ),
                        //title and price
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cProvider.cartItemList[i]['title'],
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: blackCustomColor,
                                    fontSize: 13,
                                    height: 1.3,
                                    fontWeight: FontWeight.w600),
                              ),

                              //Price and stock
                              gapH(2),

                              paragraphCommon(
                                  showWithCurrency(
                                      context,
                                      cProvider.cartItemList[i]
                                          ['priceWithAttr']),
                                  fontsize: 13,
                                  color: primaryColor,
                                  fontweight: FontWeight.w600),
                              gapH(5),

                              //Attributes
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (cProvider.cartItemList[i]['size'] != null)
                                    paragraphCommon(
                                        'Size: ${cProvider.cartItemList[i]['size']}',
                                        fontsize: 13,
                                        lineHeight: 1),

                                  gapH(4),

                                  //Color
                                  if (cProvider.cartItemList[i]['color'] !=
                                      null)
                                    Row(
                                      children: [
                                        paragraphCommon('Color:',
                                            lineHeight: 1, fontsize: 13),
                                        Container(
                                          height: 10,
                                          width: 10,
                                          alignment: Alignment.center,
                                          margin:
                                              const EdgeInsets.only(left: 4),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: Color(int.parse(cProvider
                                                .cartItemList[i]['color']
                                                .replaceAll('#', '0xff'))),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
                    //increase decrease button
                    Container(
                      // margin: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          gapW(10),
                          Container(
                            width: 110,
                            height: 39,
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: borderColor, width: 1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //decrease quanity
                                InkWell(
                                  onTap: () {
                                    cProvider
                                        .decreaseQtyAndPrice(
                                            cProvider.cartItemList[i]
                                                ['productId'],
                                            cProvider.cartItemList[i]['title'],
                                            cProvider.cartItemList[i]
                                                ['attributes'],
                                            context)
                                        .then((_) {
                                      final da =
                                          Provider.of<DeliveryAddressService>(
                                              context,
                                              listen: false);
                                      da.setVatAndincreaseTotal(
                                        da.shippingCostDetails?.tax
                                                ?.toDouble() ??
                                            0,
                                        context,
                                      );
                                    });

                                    cProvider.resetCoupon(context);
                                  },
                                  child: Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.withOpacity(.2),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.black.withOpacity(.5),
                                      size: 19,
                                    ),
                                  ),
                                ),

                                //Quantity text
                                titleCommon(
                                    '${cProvider.cartItemList[i]['qty']}',
                                    fontsize: 14),

                                //increase quantity
                                InkWell(
                                  onTap: () {
                                    cProvider
                                        .increaseQtandPrice(
                                            cProvider.cartItemList[i]
                                                ['productId'],
                                            cProvider.cartItemList[i]['title'],
                                            cProvider.cartItemList[i]
                                                ['attributes'],
                                            context)
                                        .then((_) {
                                      final da =
                                          Provider.of<DeliveryAddressService>(
                                              context,
                                              listen: false);
                                      da.setVatAndincreaseTotal(
                                        da.shippingCostDetails?.tax
                                                ?.toDouble() ??
                                            0,
                                        context,
                                      );
                                    });
                                    cProvider.resetCoupon(context);
                                  },
                                  child: Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.withOpacity(.2),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.black.withOpacity(.5),
                                      size: 19,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          gapW(7),
                          //Delete button
                          InkWell(
                            onTap: () {
                              cProvider.remove(
                                  cProvider.cartItemList[i]['productId'],
                                  cProvider.cartItemList[i]['title'],
                                  cProvider.cartItemList[i]['attributes'],
                                  context);
                            },
                            child: Container(
                                // margin: const EdgeInsets.only(left: 7),
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/trash.svg',
                                      height: 33,
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                i != cProvider.cartItemList.length - 1
                    ?
                    //don't show border to the last item
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Divider(
                          thickness: 1,
                          height: 2,
                          color: borderColor.withOpacity(.8),
                        ),
                      )
                    : Container()
              ],
            )
        ],
      ),
    );
  }
}
