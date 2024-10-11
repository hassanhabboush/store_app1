import 'package:flutter/material.dart';
import 'package:store_app/services/dropdown_services/state_dropdown_services.dart';
import 'package:store_app/view/auth/signup/dropdowns/country_states_dropdowns.dart';
import 'package:store_app/view/auth/signup/dropdowns/state_dropdown_popup.dart';
import 'package:provider/provider.dart';

import '../../../../services/dropdown_services/city_dropdown_services.dart';
import 'city_dropdown_popup.dart';

class CityDropdown extends StatelessWidget {
  const CityDropdown({Key? key, this.isFromDeliveryPage = false})
      : super(key: key);
  final bool isFromDeliveryPage;

  @override
  Widget build(BuildContext context) {
    return Consumer<CityDropdownService>(
      builder: (context, p, child) => InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return CityDropdownPopup(
                  isFromDeliveryPage: isFromDeliveryPage,
                );
              });
        },
        child: dropdownPlaceholder(hintText: p.selectedCity),
      ),
    );
  }
}
