import 'package:flutter/material.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/recent_product_service.dart';
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

class AllRecentProductsPage extends StatefulWidget {
  const AllRecentProductsPage({Key? key}) : super(key: key);

  @override
  State<AllRecentProductsPage> createState() => _AllRecentProductsPageState();
}

class _AllRecentProductsPageState extends State<AllRecentProductsPage> {
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
      appBar: appbarCommon(ConstString.allRecentProducts, context, () {
        Navigator.pop(context);
      }, actions: [
        Container(
            margin: const EdgeInsets.only(right: 25, top: 10),
            child: const CartIcon()),
      ]),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: context.watch<RecentProductService>().currentPage > 1
            ? false
            : true,
        onRefresh: () async {
          final result =
              await Provider.of<RecentProductService>(context, listen: false)
                  .fetchAllRecentProducts(context);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result =
              await Provider.of<RecentProductService>(context, listen: false)
                  .fetchAllRecentProducts(context);
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
              builder: (context, ln, child) => Consumer<RecentProductService>(
                builder: (context, provider, child) => provider
                            .noProductFound ==
                        false
                    ? provider.allRecentProducts.isNotEmpty
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
                                    itemCount:
                                        provider.allRecentProducts.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, i) {
                                      return ProductCard(
                                        imageLink: provider
                                                .allRecentProducts[i].imgUrl ??
                                            placeHolderUrl,
                                        title:
                                            provider.allRecentProducts[i].title,
                                        width: 200,
                                        oldPrice:
                                            provider.allRecentProducts[i].price,
                                        discountPrice: provider
                                            .allRecentProducts[i].discountPrice,
                                        marginRight: 5,
                                        productId:
                                            provider.allRecentProducts[i].prdId,
                                        isCartAble: provider
                                            .allRecentProducts[i].isCartAble,
                                        taxOSR: provider
                                            .allRecentProducts[i].taxOSR,
                                        ratingAverage: null,
                                        discountPercent: null,
                                        category: provider
                                            .allRecentProducts[i].categoryId,
                                        subcategory: provider
                                            .allRecentProducts[i].subCategoryId,
                                        childCategory: provider
                                            .allRecentProducts[i]
                                            .childCategoryIds,
                                        pressed: () {
                                          gotoProductDetails(
                                              context,
                                              provider
                                                  .allRecentProducts[i].prdId);
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
                        child: Text(ln.getString(ConstString.noProductFound))),
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: goToCartButton(context)
    );
  }
}
