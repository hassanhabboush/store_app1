import 'package:flutter/material.dart';
import 'package:store_app/services/dropdown_services/country_dropdown_service.dart';
import 'package:store_app/view/auth/signup/dropdowns/country_dropdown_popup.dart';
import 'package:store_app/view/auth/signup/dropdowns/country_states_dropdowns.dart';
import 'package:provider/provider.dart';

class CountryDropdown extends StatelessWidget {
  const CountryDropdown({Key? key, this.isFromDeliveryPage = false})
      : super(key: key);

  final bool isFromDeliveryPage;

  @override
  Widget build(BuildContext context) {
    return Consumer<CountryDropdownService>(
      builder: (context, p, child) => InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return CountryDropdownPopup(
                  isFromDeliveryPage: isFromDeliveryPage,
                );
              });
        },
        child: dropdownPlaceholder(hintText: p.selectedCountry),
      ),
    );
  }
}
