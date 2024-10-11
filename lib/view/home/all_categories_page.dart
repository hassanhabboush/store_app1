// import 'package:flutter/material.dart';
// import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
// import 'package:no_name_ecommerce/services/search_product_service.dart';
// import 'package:no_name_ecommerce/view/utils/common_helper.dart';
// import 'package:no_name_ecommerce/view/utils/const_strings.dart';
// import 'package:no_name_ecommerce/view/utils/constant_colors.dart';
// import 'package:no_name_ecommerce/view/utils/constant_styles.dart';
// import 'package:provider/provider.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// class AllCategoriesPage extends StatefulWidget {
//   const AllCategoriesPage({Key? key}) : super(key: key);

//   @override
//   State<AllCategoriesPage> createState() => _AllCategoriesPageState();
// }

// class _AllCategoriesPageState extends State<AllCategoriesPage> {
//   @override
//   void initState() {
//     // Provider.of<CategoryDropdownService>(context, listen: false)
//     //     .fetchCategory(context);
//     super.initState();
//   }

//   final RefreshController refreshController =
//       RefreshController(initialRefresh: true);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: appbarCommon(ConstString.allCategories, context, () {
//         Navigator.pop(context);
//       }),
//       body: SmartRefresher(
//         controller: refreshController,
//         // enablePullUp: true,
//         // enablePullDown: context.watch<SearchProductService>().currentPage > 1
//         //     ? false
//         //     : true,
//         // onRefresh: () async {
//         //   final result =
//         //       await Provider.of<SearchProductService>(context, listen: false)
//         //           .searchProducts(context);
//         //   if (result) {
//         //     refreshController.refreshCompleted();
//         //   } else {
//         //     refreshController.refreshFailed();
//         //   }
//         // },
//         // onLoading: () async {
//         //   final result =
//         //       await Provider.of<SearchProductService>(context, listen: false)
//         //           .searchProducts(context);
//         //   if (result) {
//         //     debugPrint('loadcomplete ran');
//         //     //loadcomplete function loads the data again
//         //     refreshController.loadComplete();
//         //   } else {
//         //     debugPrint('no more data');
//         //     refreshController.loadNoData();

//         //     Future.delayed(const Duration(seconds: 1), () {
//         //       //it will reset footer no data state to idle and will let us load again
//         //       refreshController.resetNoData();
//         //     });
//         //   }
//         // },
//         child: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: screenPadHorizontal),
//             child: Consumer<SearchProductService>(
//               builder: (context, provider, child) => Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     gapH(10),

//                     // provider.isLoading == false
//                     //     ? provider.productsMap.isNotEmpty
//                     //         ? provider.productsMap[0] != 'error'
//                     //
//                     // provider.noProductFound == false
//                     //     ? provider.productsMap.isNotEmpty
//                     //         ?
//                     GridView.builder(
//                         gridDelegate: const FlutterzillaFixedGridView(
//                             crossAxisCount: 2,
//                             mainAxisSpacing: 25,
//                             crossAxisSpacing: 25,
//                             height: 45),
//                         shrinkWrap: true,
//                         itemCount: 8,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemBuilder: (context, i) {
//                           return InkWell(
//                             splashColor: Colors.transparent,
//                             highlightColor: Colors.transparent,
//                             onTap: () {},
//                             child: Container(
//                               alignment: Alignment.center,
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 4),
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   border: Border.all(color: borderColor),
//                                   borderRadius: BorderRadius.circular(100)),
//                               child: Container(
//                                 margin: const EdgeInsets.symmetric(
//                                   horizontal: 13,
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: const [
//                                     // ClipRRect(
//                                     //   borderRadius: BorderRadius.circular(50),
//                                     //   child: CachedNetworkImage(
//                                     //     height: 37,
//                                     //     width: 37,
//                                     //     imageUrl:
//                                     //         provider.categoryList[i].image,
//                                     //     errorWidget: (context, url, error) =>
//                                     //         const Icon(Icons.error),
//                                     //     fit: BoxFit.cover,
//                                     //   ),
//                                     // ),

//                                     // const SizedBox(
//                                     //   width: 10,
//                                     // ),
//                                     //Title
//                                     Text(
//                                       'Casual Shirt',
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         color: greyParagraph,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         }),
//                     //     : Container(
//                     //         alignment: Alignment.center,
//                     //         margin: const EdgeInsets.only(top: 60),
//                     //         child:
//                     //             showLoading(primaryColor),
//                     //       )
//                     // : Container(
//                     //     alignment: Alignment.center,
//                     //     margin: const EdgeInsets.only(top: 60),
//                     //     child: const Text('No product found'),
//                     //   )

//                     gapH(30),
//                   ]),
//             ),
//           ),
//         ),
//       ),
//       // bottomNavigationBar: goToCartButton(context)
//     );
//   }
// }
