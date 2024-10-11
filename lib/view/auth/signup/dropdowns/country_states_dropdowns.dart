import 'package:flutter/material.dart';
import 'package:store_app/view/auth/signup/dropdowns/city_dropdown.dart';
import 'package:store_app/view/auth/signup/dropdowns/country_dropdown.dart';
import 'package:store_app/view/auth/signup/dropdowns/state_dropdown.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/responsive.dart';

class CountryStatesDropdowns extends StatefulWidget {
  const CountryStatesDropdowns({Key? key, this.isFromDeliveryPage = false})
      : super(key: key);

  final bool isFromDeliveryPage;

  @override
  State<CountryStatesDropdowns> createState() => _CountryStatesDropdownsState();
}

class _CountryStatesDropdownsState extends State<CountryStatesDropdowns> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //dropdown and search box
        const SizedBox(
          width: 17,
        ),

        // Country dropdown ===============>
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelCommon(ConstString.chooseCountry),
            CountryDropdown(
              isFromDeliveryPage: widget.isFromDeliveryPage,
            ),
          ],
        ),

        const SizedBox(
          height: 25,
        ),
        // States dropdown ===============>
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelCommon(ConstString.chooseStates),
            StateDropdown(
              isFromDeliveryPage: widget.isFromDeliveryPage,
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        // city dropdown ===============>
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelCommon(ConstString.chooseStates),
            CityDropdown(
              isFromDeliveryPage: widget.isFromDeliveryPage,
            ),
          ],
        ),
      ],
    );
  }
}

dropdownPlaceholder({required String hintText}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 17),
    decoration: BoxDecoration(
        border: Border.all(
          color: greyFive,
        ),
        borderRadius: BorderRadius.circular(50)),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      paragraphCommon(tsProvider?.getString(hintText) ?? hintText),
      const Icon(Icons.keyboard_arrow_down)
    ]),
  );
}
