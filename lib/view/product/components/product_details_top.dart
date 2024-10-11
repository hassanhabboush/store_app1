import 'package:flutter/material.dart';
import 'package:store_app/services/cart_services/favourite_service.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/product_details_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class ProductDetailsTop extends StatefulWidget {
  const ProductDetailsTop({super.key, required this.title, required this.id});

  final title;
  final id;

  @override
  State<ProductDetailsTop> createState() => _ProductDetailsTopState();
}

class _ProductDetailsTopState extends State<ProductDetailsTop> {
  bool favourite = false;

  @override
  void initState() {
    super.initState();
    checkFav();
  }

  checkFav() async {
    favourite = await Provider.of<FavouriteService>(context, listen: false)
        .checkFavourite(widget.title, widget.id);
    Future.delayed(const Duration(microseconds: 500), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslateStringService>(
      builder: (context, ln, child) => Consumer<ProductDetailsService>(
        builder: (context, provider, child) => Consumer<FavouriteService>(
          builder: (context, fProvider, child) => Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gapH(5),
                  //Title
                  Row(
                    children: [
                      Expanded(
                        child: titleCommon(
                            '${provider.productDetails?.product?.name}'),
                      ),

                      //favourite icon
                      //=======>

                      InkWell(
                        onTap: () async {
                          var provider = Provider.of<ProductDetailsService>(
                              context,
                              listen: false);

                          final usedCategories = {
                            "category":
                                provider.productDetails?.product?.category?.id,
                            "subcategory": provider
                                .productDetails?.product?.subCategory?.id,
                            "childcategory": provider
                                .productDetails?.product?.childCategory
                                .map((e) => e.id)
                                .toList(),
                          };

                          final allAttributes = provider.allAtrributes;

                          final variantId = provider.variantId;

                          await fProvider.addOrRemoveFavourite(context,
                              productId:
                                  provider.productDetails?.product?.id ?? 0,
                              title:
                                  provider.productDetails?.product?.name ?? '',
                              thumbnail:
                                  provider.productDetails?.product?.image ??
                                      placeHolderUrl,
                              taxOSR: provider.productDetails?.product?.taxOSR,
                              discountPrice:
                                  provider.productDetails?.product?.salePrice,
                              oldPrice: provider.productDetails?.product?.price,
                              priceWithAttr: provider.productSalePrice,
                              qty: provider.qty,
                              color: null,
                              size: null,
                              category: usedCategories['category'],
                              subcategory: usedCategories['subcategory'],
                              childCategory: usedCategories['childcategory'],
                              attributes: allAttributes,
                              variantId: variantId);

                          checkFav();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: borderColor)),
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(left: 20),
                            child: favourite
                                ? const Icon(
                                    Icons.favorite,
                                    color: primaryColor,
                                  )
                                : const Icon(
                                    Icons.favorite_border_outlined,
                                    color: Colors.grey,
                                  )),
                      )
                    ],
                  ),

                  Row(
                    children: [
                      //Price
                      titleCommon(
                          showWithCurrency(context,
                              provider.productDetails?.product?.salePrice),
                          color: primaryColor,
                          fontsize: 16),

                      const SizedBox(
                        width: 10,
                      ),

                      //old price
                      Text(
                        showWithCurrency(
                            context, provider.productDetails?.product?.price),
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                            decoration: TextDecoration.lineThrough),
                      )
                    ],
                  ),

                  gapH(5),

                  //Rating
                  if (provider.ratingCount > 0)
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: orangeColor,
                        ),
                        paragraphCommon('(${provider.ratingCount})')
                      ],
                    ),
                ],
              ),

              //stock status
              Row(
                children: [
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: successColor),
                          borderRadius: BorderRadius.circular(20)),
                      child: paragraphCommon(
                          provider.inStock
                              ? ln.getString(ConstString.inStock)
                              : ln.getString(ConstString.outOfStock),
                          fontsize: 11,
                          lineHeight: 1.1,
                          fontweight: FontWeight.w600,
                          color: provider.inStock ? successColor : Colors.red)),

                  //total sale
                  if (provider
                      .productDetails!.product!.inventoryDetail.isNotEmpty)
                    if (provider.productDetails!.product!.inventoryDetail[0]
                            .soldCount !=
                        null)
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 11),
                        margin: const EdgeInsets.only(top: 10, left: 9),
                        decoration: BoxDecoration(
                            color: successColor.withOpacity(.15),
                            borderRadius: BorderRadius.circular(20)),
                        child: paragraphCommon(
                          "${provider.productDetails!.product!.inventoryDetail[0].soldCount} items sold",
                          color: successColor,
                          fontsize: 11,
                          lineHeight: 1.1,
                          fontweight: FontWeight.w600,
                        ),
                      )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
