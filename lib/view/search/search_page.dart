import 'package:flutter/material.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/search_product_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/checkout/components/cart_icon.dart';
import 'package:store_app/view/home/components/product_card.dart';
import 'package:store_app/view/search/components/search_bar.dart' as sb;
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
      appBar: appbarCommon(ConstString.search, context, () {
        Navigator.pop(context);
      }, actions: [
        Container(
            margin: const EdgeInsets.only(right: 25, top: 10),
            child: const CartIcon()),
      ]),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown:
            Provider.of<SearchProductService>(context, listen: false)
                        .currentPage >
                    1
                ? false
                : true,
        onRefresh: () async {
          final result =
              await Provider.of<SearchProductService>(context, listen: false)
                  .searchProducts(context);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result =
              await Provider.of<SearchProductService>(context, listen: false)
                  .searchProducts(context);
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
              builder: (context, ln, child) => Consumer<SearchProductService>(
                builder: (context, provider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      gapH(10),
                      const sb.SearchBar(),
                      gapH(10),
                      provider.noProductFound == false
                          ? provider.productList.isNotEmpty
                              ? GridView.builder(
                                  gridDelegate: const FlutterzillaFixedGridView(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 25,
                                      crossAxisSpacing: 25,
                                      height: 266),
                                  shrinkWrap: true,
                                  itemCount: provider.productList.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    return ProductCard(
                                      imageLink:
                                          provider.productList[i].imgUrl ??
                                              placeHolderUrl,
                                      title: provider.productList[i].title,
                                      taxOSR: provider.productList[i].taxOSR,
                                      width: 180,
                                      marginRight: 0,
                                      discountPrice:
                                          provider.productList[i].discountPrice,
                                      oldPrice: provider.productList[i].price,
                                      productId: provider.productList[i].prdId,
                                      ratingAverage:
                                          provider.productList[i].avgRatting,
                                      isCartAble:
                                          provider.productList[i].isCartAble,
                                      category:
                                          provider.productList[i].categoryId,
                                      subcategory:
                                          provider.productList[i].subCategoryId,
                                      childCategory: provider
                                          .productList[i].childCategoryIds,
                                      pressed: () {
                                        gotoProductDetails(context,
                                            provider.productList[i].prdId);
                                      },
                                    );
                                  })
                              : Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top: 60),
                                  child: showLoading(primaryColor),
                                )
                          : Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 60),
                              child: Text(
                                  ln.getString(ConstString.noProductFound)),
                            ),
                      gapH(30),
                    ]),
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: goToCartButton(context)
    );
  }
}
