import 'package:flutter/material.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:store_app/services/campaign_service.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/view/campaigns/components/campaign_timer.dart';
import 'package:store_app/view/checkout/components/cart_icon.dart';
import 'package:store_app/view/home/components/product_card.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class CampaignProductByCategory extends StatelessWidget {
  const CampaignProductByCategory({super.key, required this.endDate});

  final endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarCommon('', context, (() {
        Navigator.pop(context);
      }), actions: [
        Container(
            margin: const EdgeInsets.only(right: 25, top: 10),
            child: const CartIcon()),
      ]),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Consumer<CampaignService>(
              builder: (context, p, child) => p.isLoading == false
                  ? Column(
                      children: [
                        CampaignTimer(
                          remainingTime: endDate == null
                              ? p.endDate ?? DateTime.now()
                              : DateTime.parse("$endDate"),
                        ),
                        gapH(30),
                        GridView.builder(
                            gridDelegate: const FlutterzillaFixedGridView(
                                crossAxisCount: 2,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                                height: 266),
                            shrinkWrap: true,
                            itemCount: p.productList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) {
                              return ProductCard(
                                imageLink:
                                    p.productList[i].imgUrl ?? placeHolderUrl,
                                title: p.productList[i].title,
                                taxOSR: p.productList[i].taxOSR,
                                width: double.infinity,
                                oldPrice: p.productList[i].price,
                                discountPrice: p.productList[i].discountPrice,
                                marginRight: 5,
                                productId: p.productList[i].prdId,
                                ratingAverage: p.productList[i].avgRatting,
                                discountPercent:
                                    p.productList[i].campaignPercentage,
                                isCartAble: p.productList[i].isCartAble,
                                category: p.productList[i].categoryId,
                                subcategory: p.productList[i].subCategoryId,
                                childCategory:
                                    p.productList[i].childCategoryIds,
                                pressed: () {
                                  gotoProductDetails(
                                      context, p.productList[i].prdId);
                                },
                              );
                            })
                      ],
                    )
                  : Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: showLoading(primaryColor),
                    ),
            )),
      ),
    );
  }
}
