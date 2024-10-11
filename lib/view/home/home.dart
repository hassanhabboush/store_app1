import 'package:flutter/material.dart';
import 'package:store_app/services/campaign_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/view/home/components/categories_horizontal.dart';
import 'package:store_app/view/home/components/home_top.dart';
import 'package:store_app/view/campaigns/components/campaign_list.dart';
import 'package:store_app/view/product/components/featured_products.dart';
import 'package:store_app/view/home/components/slider_home.dart';
import 'package:store_app/view/home/homepage_helper.dart';
import 'package:store_app/view/product/components/recent_products.dart';
import 'package:store_app/view/search/search_page.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    runAtHomeScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CampaignService>(context, listen: false)
        .fetchCampaignList(context);
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Consumer<TranslateStringService>(
            builder: (context, asProvider, child) =>
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              gapH(10),

              //name and profile image
              const HomeTop(),
              Expanded(
                  child: SingleChildScrollView(
                physics: globalPhysics,
                child: Column(
                  children: [
                    //Search bar ========>
                    gapH(12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const SearchPage(),
                              ),
                            );
                          },
                          child:
                              HomepageHelper().searchbar(asProvider, context)),
                    ),

                    //Slider ========>
                    const SliderHome(),

                    gapH(14),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Column(children: [
                        //categories
                        const CategoriesHorizontal(),

                        const RecentProducts(),

                        //Featured product
                        const FeaturedProducts(),

                        gapH(20),

                        //campaign product
                        const CampaignList(),
                      ]),
                    )
                  ],
                ),
              ))
            ]),
          ),
        ),
      ),
    );
  }
}
