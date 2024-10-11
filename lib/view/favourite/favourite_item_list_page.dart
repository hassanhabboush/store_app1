import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_app/services/cart_services/cart_service.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/cart_services/favourite_service.dart';
import 'package:store_app/services/product_details_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/responsive.dart';
import 'package:provider/provider.dart';

class FavouriteItemListPage extends StatefulWidget {
  const FavouriteItemListPage({Key? key}) : super(key: key);

  @override
  State<FavouriteItemListPage> createState() => _FavouriteItemListPageState();
}

class _FavouriteItemListPageState extends State<FavouriteItemListPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<FavouriteService>(context, listen: false).fetchFavProducts();
  }

  List favPopupList = [
    ConstString.viewDetails,
    ConstString.addToCart,
    ConstString.removeFromFav
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarCommon(ConstString.favourite, context, () {},
          hasBackButton: false),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenPadHorizontal),
          child: Consumer<TranslateStringService>(
            builder: (context, ln, child) => Consumer<ProductDetailsService>(
              builder: (context, pProvider, child) =>
                  Consumer<FavouriteService>(
                builder: (context, fProvider, child) => fProvider
                        .favItemList.isNotEmpty
                    ? Column(children: [
                        gapH(10),
                        for (int i = 0; i < fProvider.favItemList.length; i++)
                          InkWell(
                            onTap: () {
                              gotoProductDetails(context,
                                  fProvider.favItemList[i]['productId']);
                            },
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    //title image price
                                    Expanded(
                                        child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        commonImage(
                                            fProvider.favItemList[i]
                                                ['thumbnail'],
                                            55,
                                            55),

                                        const SizedBox(
                                          width: 10,
                                        ),
                                        //title and price
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${fProvider.favItemList[i]['title']}',
                                                textAlign: TextAlign.left,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: blackCustomColor,
                                                    fontSize: 13,
                                                    height: 1.4,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),

                                              //Price and stock
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                showWithCurrency(
                                                    context,
                                                    fProvider.favItemList[i]
                                                        ['discountPrice']),
                                                textAlign: TextAlign.left,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),

                                    //popup
                                    // ========>

                                    PopupMenuButton(
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry>[
                                        //view details
                                        PopupMenuItem(
                                          onTap: () {
                                            Future.delayed(Duration.zero, () {
                                              gotoProductDetails(
                                                  context,
                                                  fProvider.favItemList[i]
                                                      ['productId']);
                                            });
                                          },
                                          child: Text(
                                              ln.getString(favPopupList[0])),
                                        ),

                                        //add to cart

                                        if (jsonDecode(fProvider.favItemList[i]
                                                ['attributes'])
                                            .isEmpty)
                                          PopupMenuItem(
                                            onTap: () {
                                              Future.delayed(Duration.zero, () {
                                                var cProvider =
                                                    Provider.of<CartService>(
                                                        context,
                                                        listen: false);

                                                cProvider.addToCartOrUpdateQty(context,
                                                    title: fProvider.favItemList[i]
                                                        ['title'],
                                                    thumbnail: fProvider.favItemList[i]
                                                        ['thumbnail'],
                                                    discountPrice: fProvider
                                                        .favItemList[i]
                                                            ['discountPrice']
                                                        .toString(),
                                                    oldPrice: fProvider.favItemList[i]
                                                            ['oldPrice']
                                                        .toString(),
                                                    priceWithAttr:
                                                        fProvider.favItemList[i]
                                                            ['priceWithAttr'],
                                                    qty: 1,
                                                    color: null,
                                                    size: null,
                                                    productId: fProvider
                                                        .favItemList[i]['productId']
                                                        .toString(),
                                                    category: fProvider.favItemList[i]['category'],
                                                    taxOSR: fProvider.favItemList[i]['tax_options_sum_rate'],
                                                    subcategory: fProvider.favItemList[i]['subcategory'],
                                                    childCategory: fProvider.favItemList[i]['childCategory'],
                                                    attributes: {},
                                                    variantId: fProvider.favItemList[i]['variantId'],
                                                    ignoreAttribute: true);
                                              });
                                            },
                                            child: Text(
                                                ln.getString(favPopupList[1])),
                                          ),

                                        //remove from favourite
                                        PopupMenuItem(
                                          onTap: () {
                                            Future.delayed(Duration.zero, () {
                                              //Delete
                                              fProvider.addOrRemoveFavourite(
                                                  context,
                                                  productId:
                                                      fProvider.favItemList[i]
                                                          ['productId'],
                                                  thumbnail: '',
                                                  discountPrice: '',
                                                  oldPrice: '',
                                                  title:
                                                      fProvider.favItemList[i]
                                                              ['title'] ??
                                                          '',
                                                  taxOSR: fProvider
                                                              .favItemList[i][
                                                          'tax_options_sum_rate'] ??
                                                      '',
                                                  attributes: null,
                                                  category: null,
                                                  childCategory: null,
                                                  color: null,
                                                  priceWithAttr: null,
                                                  qty: 1,
                                                  size: null,
                                                  subcategory: null,
                                                  variantId: null);
                                            });
                                          },
                                          child: Text(
                                              ln.getString(favPopupList[2])),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: dividerCommon(),
                                )
                              ],
                            ),
                          ),
                        gapH(30)
                      ])
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
                                  image:
                                      AssetImage('assets/images/wishlist.png'),
                                  // fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            titleCommon(
                                ln.getString(ConstString.nothingInWishlist),
                                fontweight: FontWeight.w600,
                                fontsize: 23),
                            gapH(10),
                            paragraphCommon(ln.getString(
                                ConstString.nothingInWishlistAddFromStore))
                          ],
                        ),
                      ),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
