// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:store_app/services/cart_services/delivery_address_service.dart';
import 'package:store_app/services/dropdown_services/country_dropdown_service.dart';
import 'package:store_app/services/dropdown_services/state_dropdown_services.dart';
import 'package:store_app/services/rtl_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/custom_input.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../services/dropdown_services/city_dropdown_services.dart';

class CountryDropdownPopup extends StatelessWidget {
  const CountryDropdownPopup({Key? key, this.isFromDeliveryPage = false})
      : super(key: key);

  final bool isFromDeliveryPage;

  @override
  Widget build(BuildContext context) {
    final RefreshController refreshController =
        RefreshController(initialRefresh: true);

    return Scaffold(
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: context.watch<CountryDropdownService>().currentPage > 1
            ? false
            : true,
        onRefresh: () async {
          final result =
              await Provider.of<CountryDropdownService>(context, listen: false)
                  .fetchCountries(context);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result =
              await Provider.of<CountryDropdownService>(context, listen: false)
                  .fetchCountries(context);
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Consumer<RtlService>(
              builder: (_, rtl, child) => Consumer<TranslateStringService>(
                builder: (_, ln, child) => Consumer<DeliveryAddressService>(
                    builder: (_, dProvider, child) => (dProvider.isLoading ==
                                true &&
                            isFromDeliveryPage == true)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              gapH(50),
                              paragraphCommon(ln.getString(
                                  ConstString.settingShipChargePlzWait)),
                              gapH(10),
                              showLoading(primaryColor)
                            ],
                          )
                        : Consumer<CountryDropdownService>(
                            builder: (cPContext, p, child) => Column(
                              children: [
                                gapH(30),
                                CustomInput(
                                  hintText: ConstString.searchCountry,
                                  paddingHorizontal: 17,
                                  icon: 'assets/icons/search.png',
                                  onChanged: (v) {
                                    p.searchCountry(context, v,
                                        isSearching: true);
                                  },
                                ),
                                gapH(10),
                                p.countryDropdownList.isNotEmpty
                                    ? p.countryDropdownList[0] !=
                                            ConstString.selectCountry
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                p.countryDropdownList.length,
                                            itemBuilder: (listContext, i) {
                                              return InkWell(
                                                onTap: () async {
                                                  p.setCountryValue(
                                                      p.countryDropdownList[i]);

                                                  //                         // setting the id of selected value
                                                  p.setSelectedCountryId(
                                                      p.countryDropdownIndexList[p
                                                          .countryDropdownList
                                                          .indexOf(
                                                              p.countryDropdownList[
                                                                  i])]);

                                                  Provider.of<StateDropdownService>(
                                                          context,
                                                          listen: false)
                                                      .setStateDefault();

                                                  if (isFromDeliveryPage) {
                                                    await Provider.of<
                                                                DeliveryAddressService>(
                                                            context,
                                                            listen: false)
                                                        .fetchCountryStateShippingCost(
                                                            context);
                                                  }

                                                  Provider.of<CityDropdownService>(
                                                          context,
                                                          listen: false)
                                                      .setCityDefault();

                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 18),
                                                  decoration: const BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color:
                                                                  greyFive))),
                                                  child: paragraphCommon(
                                                    '${p.countryDropdownList[i]}',
                                                    textAlign: rtl.rtl == false
                                                        ? TextAlign.left
                                                        : TextAlign.right,
                                                  ),
                                                ),
                                              );
                                            })
                                        : paragraphCommon(
                                            ConstString.noCountryFound)
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [showLoading(primaryColor)],
                                      )
                              ],
                            ),
                          )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
