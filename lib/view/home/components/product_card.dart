// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_app/services/cart_services/cart_service.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/rtl_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/responsive.dart';
import 'package:provider/provider.dart';

import '../../utils/constant_colors.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.imageLink,
    required this.title,
    required this.width,
    required this.marginRight,
    required this.pressed,
    required this.productId,
    required this.oldPrice,
    required this.discountPrice,
    required this.ratingAverage,
    this.ratingCount,
    this.discountPercent,
    required this.isCartAble,
    required this.category,
    required this.subcategory,
    required this.childCategory,
    required this.taxOSR,
  }) : super(key: key);

  final productId;
  final imageLink;
  final title;
  final oldPrice;
  final discountPrice;
  final ratingAverage;
  final ratingCount;
  final discountPercent;
  final double width;
  final double marginRight;
  final VoidCallback pressed;
  final isCartAble;
  final category;
  final subcategory;
  final childCategory;
  final taxOSR;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: pressed,
      child: Consumer<CartService>(
        builder: (context, cProvider, child) => Consumer<RtlService>(
          builder: (context, rtlP, child) => Container(
            alignment: Alignment.center,
            width: width,
            margin: EdgeInsets.only(
              right: rtlP.rtl == false ? marginRight : 0,
              left: rtlP.rtl == false ? 0 : marginRight,
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(9)),
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        height: 150,
                        width: double.infinity,
                        imageUrl: imageLink,
                        placeholder: (context, url) => Icon(
                          Icons.image_outlined,
                          size: 45,
                          color: Colors.grey.withOpacity(.4),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),

                    // off percent / discount
                    if (discountPercent != null && discountPercent != 0)
                      Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            color: primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            child: paragraphCommon(
                                '${discountPercent.toStringAsFixed(0)}% off',
                                color: Colors.white),
                          ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapH(10),
                    //Title
                    Text(
                      title.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: blackCustomColor,
                          fontSize: 14,
                          height: 1.3,
                          fontWeight: FontWeight.w600),
                    ),

                    gapH(5),
                    //Price
                    Row(
                      children: [
                        paragraphCommon(
                            showWithCurrency(context, discountPrice),
                            lineHeight: 1.2,
                            fontsize: 14,
                            color: primaryColor,
                            fontweight: FontWeight.w600),

                        const SizedBox(
                          width: 7,
                        ),

                        //old price
                        Text(
                          showWithCurrency(context, oldPrice),
                          style: TextStyle(
                              color: Colors.grey[600],
                              decoration: TextDecoration.lineThrough),
                        )
                      ],
                    ),

                    gapH(4),

                    //Rating
                    if (ratingAverage != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: orangeColor,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          paragraphCommon('${ratingAverage ?? 0.0}',
                              lineHeight: 1,
                              fontsize: 13,
                              color: greyParagraph,
                              fontweight: FontWeight.bold),
                          const SizedBox(
                            width: 5,
                          ),
                          if (ratingCount != null)
                            paragraphCommon('(${ratingCount ?? 0})',
                                lineHeight: 1, fontsize: 13)
                        ],
                      ),

                    isCartAble == true
                        ? addToCartViewDetailsBtn(context, () {
                            cProvider.addToCartOrUpdateQty(context,
                                title: title ?? '',
                                thumbnail: imageLink ?? placeHolderUrl,
                                discountPrice: discountPrice.toString(),
                                oldPrice: oldPrice.toString(),
                                priceWithAttr: discountPrice,
                                qty: 1,
                                color: null,
                                size: null,
                                productId: productId.toString(),
                                category: category,
                                subcategory: subcategory,
                                childCategory: childCategory.isNotEmpty
                                    ? childCategory[0]
                                    : '0',
                                attributes: {},
                                taxOSR: taxOSR,
                                variantId: null,
                                ignoreAttribute: true);
                          },
                            tsProvider?.getString(ConstString.addToCart) ??
                                ConstString.addToCart)
                        : addToCartViewDetailsBtn(context, () {
                            gotoProductDetails(context, productId);
                          },
                            tsProvider?.getString(ConstString.viewDetails) ??
                                ConstString.addToCart),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell addToCartViewDetailsBtn(
      BuildContext context, VoidCallback onTap, String btnText) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
            border: Border.all(color: greyFive, width: .8),
            borderRadius: BorderRadius.circular(4)),
        child: Text(
          btnText,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 11, color: greyParagraph, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
