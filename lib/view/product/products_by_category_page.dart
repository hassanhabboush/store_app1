import 'package:flutter/material.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/product_by_category_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/checkout/components/cart_icon.dart';
import 'package:store_app/view/home/components/product_card.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:store_app/view/utils/responsive.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductsByCategoryPage extends StatefulWidget {
  const ProductsByCategoryPage({Key? key, required this.categoryName})
      : super(key: key);

  final categoryName;

  @override
  State<ProductsByCategoryPage> createState() => _ProductsByCategoryPageState();
}

class _ProductsByCategoryPageState extends State<ProductsByCategoryPage> {
  @override
  void initState() {
    super.initState();
  }

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarCommon('', context, () {
        Navigator.pop(context);
        Provider.of<ProductByCategoryService>(context, listen: false)
            .setEverythingToDefault();
      }, actions: [
        Container(
            margin: const EdgeInsets.only(right: 25, top: 10),
            child: const CartIcon()),
      ]),
      body: WillPopScope(
        onWillPop: () {
          Provider.of<ProductByCategoryService>(context, listen: false)
              .setEverythingToDefault();

          return Future.value(true);
        },
        child: SmartRefresher(
          controller: refreshController,
          enablePullUp: true,
          enablePullDown:
              context.watch<ProductByCategoryService>().currentPage > 1
                  ? false
                  : true,
          onRefresh: () async {
            final result = await Provider.of<ProductByCategoryService>(context,
                    listen: false)
                .fetchProductByCategory(context, widget.categoryName);
            if (result) {
              refreshController.refreshCompleted();
            } else {
              refreshController.refreshFailed();
            }
          },
          onLoading: () async {
            final result = await Provider.of<ProductByCategoryService>(context,
                    listen: false)
                .fetchProductByCategory(context, widget.categoryName);
            if (result) {
              debugPrint('loadcomplete ran');
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
                builder: (context, ln, child) =>
                    Consumer<ProductByCategoryService>(
                  builder: (context, provider, child) => provider
                              .noProductFound ==
                          false
                      ? provider.productList.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  gapH(10),
                                  GridView.builder(
                                      gridDelegate:
                                          const FlutterzillaFixedGridView(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 25,
                                              crossAxisSpacing: 20,
                                              height: 266),
                                      shrinkWrap: true,
                                      itemCount: provider.productList.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, i) {
                                        return ProductCard(
                                          imageLink:
                                              provider.productList[i].imgUrl ??
                                                  placeHolderUrl,
                                          title: provider.productList[i].title,
                                          width: 200,
                                          oldPrice:
                                              provider.productList[i].price,
                                          taxOSR:
                                              provider.productList[i].taxOSR,
                                          discountPrice: provider
                                              .productList[i].discountPrice,
                                          marginRight: 5,
                                          productId:
                                              provider.productList[i].prdId,
                                          ratingAverage: provider
                                              .productList[i].avgRatting,
                                          discountPercent: provider
                                              .productList[i]
                                              .campaignPercentage,
                                          isCartAble: provider
                                              .productList[i].isCartAble,
                                          category: provider
                                              .productList[i].categoryId,
                                          subcategory: provider
                                              .productList[i].subCategoryId,
                                          childCategory: provider
                                              .productList[i].childCategoryIds,
                                          pressed: () {
                                            gotoProductDetails(context,
                                                provider.productList[i].prdId);
                                          },
                                        );
                                      })
                                ])
                          : Container(
                              alignment: Alignment.center,
                              height: getScreenHeight(context) - 200,
                              child: showLoading(primaryColor),
                            )
                      : Container(
                          alignment: Alignment.center,
                          height: getScreenHeight(context) - 200,
                          child: Text(ln.getString(ConstString.noProductFound)),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: goToCartButton(context)
    );
  }
}
