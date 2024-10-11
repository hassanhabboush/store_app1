// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_app/services/product_details_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/checkout/components/cart_icon.dart';
import 'package:store_app/view/campaigns/components/campaign_timer.dart';
import 'package:store_app/view/product/components/color_size.dart';
import 'package:store_app/view/product/components/description_tab.dart';
import 'package:store_app/view/product/components/product_details_bottom.dart';
import 'package:store_app/view/product/components/product_details_qty.dart';
import 'package:store_app/view/product/components/product_details_skeleton.dart';
import 'package:store_app/view/product/components/product_details_slider.dart';
import 'package:store_app/view/product/components/product_details_top.dart';
import 'package:store_app/view/product/components/review_tab.dart';
import 'package:store_app/view/product/components/ship_return_tab.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({
    Key? key,
    required this.productId,
  }) : super(key: key);

  final productId;

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 0;

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      if (mounted) {
        setState(() {
          _tabIndex = _tabController.index;
        });
      }
    }
  }

  int currentTab = 0;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: greyFour),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 25, top: 10),
            child: const CartIcon(),
          )
        ],
      ),
      body: Consumer<TranslateStringService>(
        builder: (context, ln, child) => Consumer<ProductDetailsService>(
          builder: (context, provider, child) => provider.productDetails != null
              ? Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Slider =============>
                              const ProductDetailsSlider(),

                              gapH(16),
                              if (provider.productDetails?.product?.inventory
                                      ?.sku !=
                                  null)
                                paragraphCommon(
                                    'SKU:  ${provider.productDetails?.product?.inventory?.sku}'),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProductDetailsTop(
                                    title:
                                        provider.productDetails?.product?.name,
                                    id: provider.productDetails?.product?.id,
                                  ),

                                  //=========>
                                  const ColorAndSize(),

                                  //increase decrease button
                                  gapH(17),
                                  paragraphCommon(
                                      ln.getString(ConstString.quantity) + ':'),
                                  gapH(10),
                                  const ProductDetailsQty(),

                                  gapH(25),
                                  if (provider.productDetails?.product
                                          ?.campaignProduct !=
                                      null)
                                    CampaignTimer(
                                      remainingTime: DateTime.parse(provider
                                          .productDetails
                                          ?.product
                                          ?.campaignProduct['end_date']),
                                    ),

                                  //========>
                                  // tab
                                  gapH(15),

                                  TabBar(
                                    onTap: (value) {
                                      setState(() {
                                        currentTab = value;
                                      });
                                    },
                                    labelColor: primaryColor,
                                    unselectedLabelColor: greyFour,
                                    indicatorColor: primaryColor,
                                    isScrollable: true,
                                    unselectedLabelStyle: const TextStyle(
                                        color: greyParagraph,
                                        fontWeight: FontWeight.normal),
                                    controller: _tabController,
                                    tabs: [
                                      Tab(text: ln.getString(ConstString.desc)),
                                      Tab(
                                          text:
                                              ln.getString(ConstString.review)),
                                      Tab(
                                          text: ln.getString(
                                              ConstString.shipAndReturn)),
                                    ],
                                  ),

                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 15, bottom: 30),
                                    child: [
                                      const DescriptionTab(),
                                      const ReviewTab(),
                                      const ShipReturnTab(),
                                    ][_tabIndex],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    //=======>
                    ProductDetailsBottom(
                      tabIndex: currentTab,
                    )
                  ],
                )
              : const ProductDetailsSkeleton(),
        ),
      ),
    );
  }
}
