import 'package:flutter/material.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/featured_product_service.dart';
import 'package:store_app/view/home/components/product_card.dart';
import 'package:store_app/view/home/components/section_title.dart';
import 'package:store_app/view/product/all_featured_products_page.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:provider/provider.dart';

import '../../utils/constant_colors.dart';
import '../../utils/constant_styles.dart';
import '../../utils/others_helper.dart';

class FeaturedProducts extends StatelessWidget {
  const FeaturedProducts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FeaturedProductService>(
      builder: (context, p, child) => Column(
        children: [
          if (p.featuredProducts == null ||
              (p.featuredProducts?.data.isNotEmpty ?? true == true))
            Column(
              children: [
                gapH(24),
                SectionTitle(
                  title: ConstString.featuredProducts,
                  pressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const AllFeaturedProductsPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 18,
                ),
                // if (p.featuredProducts == null) showLoading(primaryColor),
              ],
            ),
          if (p.featuredProducts?.data.isNotEmpty ?? false == true)
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: 266,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                clipBehavior: Clip.none,
                children: [
                  for (int i = 0; i < p.featuredProducts!.data.length; i++)
                    ProductCard(
                      imageLink:
                          p.featuredProducts?.data[i].imgUrl ?? placeHolderUrl,
                      title: p.featuredProducts?.data[i].title,
                      taxOSR: p.featuredProducts?.data[i].taxOSR,
                      width: 180,
                      oldPrice: p.featuredProducts?.data[i].price,
                      discountPrice: p.featuredProducts?.data[i].discountPrice,
                      marginRight: 20,
                      productId: p.featuredProducts?.data[i].prdId,
                      ratingAverage: p.featuredProducts?.data[i].avgRatting,
                      discountPercent:
                          p.featuredProducts?.data[i].campaignPercentage,
                      isCartAble: p.featuredProducts?.data[i].isCartAble,
                      category: p.featuredProducts?.data[i].categoryId,
                      subcategory: p.featuredProducts?.data[i].subCategoryId,
                      childCategory:
                          p.featuredProducts?.data[i].childCategoryIds,
                      pressed: () {
                        gotoProductDetails(
                            context, p.featuredProducts?.data[i].prdId);
                      },
                    )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
