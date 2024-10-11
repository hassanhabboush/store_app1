import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:store_app/services/category_service.dart';
import 'package:store_app/services/child_category_service.dart';
import 'package:store_app/services/filter_color_size_service.dart';
import 'package:store_app/services/search_product_service.dart';
import 'package:store_app/services/subcategory_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/home/components/categories.dart';
import 'package:store_app/view/home/components/child_categories.dart';
import 'package:store_app/view/home/components/sub_categories.dart';
import 'package:store_app/view/search/components/color_size_for_filter.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class ProductFilter extends StatefulWidget {
  const ProductFilter({Key? key}) : super(key: key);

  @override
  State<ProductFilter> createState() => _ProductFilterState();
}

class _ProductFilterState extends State<ProductFilter> {
  @override
  void initState() {
    super.initState();
    fillInitialData();
  }

  late RangeValues _currentRangeValues;

  fillInitialData() {
    dynamic startPrice;
    dynamic endPrice;

    startPrice =
        Provider.of<SearchProductService>(context, listen: false).minPrice;
    endPrice =
        Provider.of<SearchProductService>(context, listen: false).maxPrice;
    Provider.of<CategoryService>(context, listen: false).fetchCategory(context);

    startPrice = double.parse(startPrice);
    endPrice = double.parse(endPrice);

    _currentRangeValues = RangeValues(startPrice, endPrice);
  }

  int selectedCategory = 0;
  int selectedColor = 0;

  // final minPriceController = TextEditingController();
  // final maxPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslateStringService>(
      builder: (context, ln, child) => Consumer<SearchProductService>(
        builder: (context, provider, child) => Container(
          // height: getScreenHeight(context) / 2 + 300,
          color: Colors.white,
          padding: EdgeInsets.symmetric(
              horizontal: screenPadHorizontal, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleCommon(ln.getString(ConstString.filterBy) + ':'),
                gapH(20),

                //Category =====>
                paragraphCommon(ln.getString(ConstString.category) + ':'),
                gapH(12),
                const Categories(),

                //Sub Category =====>
                gapH(20),
                paragraphCommon(ln.getString(ConstString.subCategory) + ':'),
                gapH(12),
                const SubCategories(),

                //Child Category =====>
                gapH(20),
                paragraphCommon(ln.getString(ConstString.childCategory) + ':'),
                gapH(12),
                const ChildCategories(),

                //=========>
                const ColorAndSizeForFilter(),

                //Price range =========>
                gapH(18),
                paragraphCommon(ln.getString(ConstString.priceRange) + ':'),

                SliderTheme(
                  data: const SliderThemeData(
                    trackHeight: 1,
                  ),
                  child: RangeSlider(
                    values: _currentRangeValues,
                    max: 2000,
                    divisions: 20,
                    activeColor: primaryColor,
                    inactiveColor: Colors.grey.withOpacity(.2),
                    labels: RangeLabels(
                      _currentRangeValues.start.round().toString(),
                      _currentRangeValues.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      provider
                          .setMinPrice(_currentRangeValues.start.toString());
                      provider.setMaxPrice(_currentRangeValues.end.toString());
                      setState(() {
                        _currentRangeValues = values;
                      });
                    },
                  ),
                ),

                // Row(
                //   children: [
                //     Expanded(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           paragraphCommon(
                //               ln.getString(ConstString.minPrice) + ':'),
                //           gapH(10),
                //           CustomInput(
                //             hintText: ln.getString(ConstString.enterMinPrice),
                //             borderRadius: 5,
                //             paddingHorizontal: 15,
                //             isNumberField: true,
                //             controller: minPriceController,
                //             onChanged: (v) {
                //               provider.setMinPrice(v);
                //             },
                //           ),
                //         ],
                //       ),
                //     ),
                //     gapW(20),
                //     Expanded(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           paragraphCommon(
                //               ln.getString(ConstString.maxPrice) + ':'),
                //           gapH(10),
                //           CustomInput(
                //             hintText: ln.getString(ConstString.enterMaxPrice),
                //             borderRadius: 5,
                //             paddingHorizontal: 15,
                //             isNumberField: true,
                //             controller: maxPriceController,
                //             onChanged: (v) {
                //               provider.setMaxPrice(v);
                //             },
                //           ),
                //         ],
                //       ),
                //     )
                //   ],
                // ),

                paragraphCommon(ln.getString(ConstString.ratings) + ':'),
                gapH(10),
                RatingBar.builder(
                  initialRating: provider.rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
                  itemSize: 30,
                  unratedColor: greyFive,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (value) {
                    provider.setRating(value);
                  },
                ),

                // Reset filter and apply button
                gapH(20),
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        provider.setRating(5.0);
                        Provider.of<CategoryService>(context, listen: false)
                            .setFirstValue();
                        Provider.of<SubCategoryService>(context, listen: false)
                            .setFirstValue();
                        Provider.of<ChildCategoryService>(context,
                                listen: false)
                            .setFirstValue();

                        provider.setMinPrice('');
                        provider.setMaxPrice('');

                        //clear color size
                        Provider.of<FilterColorSizeService>(context,
                                listen: false)
                            .setDefault();

                        // minPriceController.clear();
                        // maxPriceController.clear();
                      },
                      child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                              color: const Color(0xffEAECF0),
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            ln.getString(ConstString.clear),
                            style: const TextStyle(
                              color: Color(0xff667085),
                              fontSize: 14,
                            ),
                          )),
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: buttonPrimary(ConstString.apply, () {
                        Navigator.pop(context);
                        provider.searchProducts(context, isSearching: true);
                      }, borderRadius: 100),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
