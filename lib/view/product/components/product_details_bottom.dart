// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:store_app/services/cart_services/cart_service.dart';
import 'package:store_app/services/product_db_service.dart';
import 'package:store_app/services/product_details_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/checkout/cart_page.dart';
import 'package:store_app/view/product/components/write_review_page.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

import '../../../services/cart_services/delivery_address_service.dart';
import '../../../services/dropdown_services/city_dropdown_services.dart';
import '../../../services/dropdown_services/country_dropdown_service.dart';
import '../../../services/dropdown_services/state_dropdown_services.dart';
import '../../../services/profile_service.dart';

class ProductDetailsBottom extends StatefulWidget {
  const ProductDetailsBottom({
    Key? key,
    required this.tabIndex,
  }) : super(key: key);

  final tabIndex;

  @override
  State<ProductDetailsBottom> createState() => _ProductDetailsBottomState();
}

class _ProductDetailsBottomState extends State<ProductDetailsBottom> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslateStringService>(
      builder: (context, ln, child) => Container(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 17),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Consumer<ProductDetailsService>(
          builder: (context, provider, child) => Column(
            children: [
              widget.tabIndex == 1
                  ? Column(
                      children: [
                        buttonPrimary(ConstString.writeReview, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  WriteReviewPage(
                                productId: provider.productDetails?.product?.id,
                              ),
                            ),
                          );
                        }, bgColor: successColor, borderRadius: 100),
                        const SizedBox(
                          height: 13,
                        ),
                      ],
                    )
                  : Container(),
              Consumer<CartService>(
                builder: (context, cProvider, child) => Row(
                  children: [
                    Expanded(
                        child: buttonPrimary(ConstString.buyNow, (() async {
                      if (provider.allAtrributes.isNotEmpty &&
                          provider.selectedInventorySet.isEmpty) {
                        showToast(
                            ln.getString(ConstString.youMustSelectAllAttr),
                            Colors.black);
                        return;
                      }

                      bool addedAlready = await ProductDbService()
                          .checkIfAddedtoCart(
                              provider.productDetails?.product?.name ?? '',
                              provider.productDetails?.product?.id ?? 1);

                      if (!addedAlready) {
                        await addToCart(context);
                      }

                      Provider.of<DeliveryAddressService>(context,
                              listen: false)
                          .cleatDeliveryAddress();
                      final productDetails =
                          Provider.of<ProfileService>(context, listen: false)
                              .profileDetails;

                      final country = Provider.of<CountryDropdownService>(
                          context,
                          listen: false);

                      country.setSelectedCountryId(productDetails
                          ?.userDetails.deliveryAddress?.countryId);
                      // Provider.of<CountryDropdownService>(context, listen: false)
                      //     .setCountryValue(productDetails?.userDetails.userCountry?.name);
                      final state = Provider.of<StateDropdownService>(context,
                          listen: false);
                      state.setSelectedStatesId(
                          productDetails?.userDetails.deliveryAddress?.stateId);
                      // Provider.of<StateDropdownService>(context, listen: false)
                      //     .setStatesValue(productDetails?.userDetails.userState?.name);
                      final city = Provider.of<CityDropdownService>(context,
                          listen: false);
                      city.setSelectedCityId(
                          productDetails?.userDetails.deliveryAddress?.city);
                      // Provider.of<CityDropdownService>(context, listen: false)
                      //     .setSelectedCityId(productDetails?.userDetails.city?.id);

                      Provider.of<DeliveryAddressService>(context,
                              listen: false)
                          .fetchCountryStateShippingCost(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const Cartpage(),
                        ),
                      );
                    }),
                            borderRadius: 100,
                            bgColor: Colors.grey[200],
                            fontColor: Colors.grey[800])),
                    const SizedBox(
                      width: 15,
                    ),
                    //======>
                    Expanded(
                      child: buttonPrimary(ConstString.addToCart, () {
                        print(provider.productSalePrice);

                        if (provider.allAtrributes.isNotEmpty &&
                            provider.selectedInventorySet.isEmpty) {
                          showToast(
                              ln.getString(ConstString.youMustSelectAllAttr),
                              Colors.black);
                          return;
                        }

                        addToCart(context);
                      }, borderRadius: 100),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addToCart(BuildContext context) {
    var cProvider = Provider.of<CartService>(context, listen: false);
    var provider = Provider.of<ProductDetailsService>(context, listen: false);

    final usedCategories = {
      "category": provider.productDetails?.product?.category?.id,
      "subcategory": provider.productDetails?.product?.subCategory?.id,
      "childcategory": provider.productDetails?.product?.childCategory
          .map((e) => e.id)
          .toList(),
    };

    final attributes = provider.selectedInventorySet;
    if (attributes.containsKey('color_code')) {
      attributes.putIfAbsent(
          'Color',
          () => provider.productDetails?.productColors
              .firstWhere(
                  (element) => element.colorCode == attributes['color_code'])
              .name);
    }
    print(attributes);

    final variantId = provider.variantId;
    print(variantId);

    cProvider.addToCartOrUpdateQty(context,
        title: provider.productDetails?.product?.name ?? '',
        thumbnail: provider.additionalInfoImage ??
            provider.productDetails?.product?.image ??
            placeHolderUrl,
        discountPrice:
            provider.productDetails?.product?.salePrice.toString() ?? '0',
        oldPrice: provider.productDetails?.product?.price.toString() ?? '0',
        taxOSR: provider.productDetails?.product?.taxOSR.toString() ?? '0',
        priceWithAttr: provider.productSalePrice,
        qty: provider.qty,
        color: provider.selectedInventorySet['color_code'],
        size: provider.selectedInventorySet['Size'],
        productId: provider.productDetails?.product?.id.toString() ?? '1',
        category: usedCategories['category'],
        subcategory: usedCategories['subcategory'],
        childCategory: usedCategories['childcategory'],
        attributes: attributes,
        variantId: variantId);
  }
}
