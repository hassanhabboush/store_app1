import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/services/dropdown_services/country_dropdown_service.dart';
import 'package:store_app/services/dropdown_services/state_dropdown_services.dart';
import 'package:store_app/services/profile_service.dart';
import 'package:store_app/services/shipping_services/shipping_list_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dropdown_services/city_dropdown_services.dart';

class AddRemoveShippingAddressService with ChangeNotifier {
  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  addAddress(
    context, {
    required shippingName,
    required name,
    required email,
    required phone,
    required address,
    required zip,
  }) async {
    var ln = Provider.of<TranslateStringService>(context, listen: false);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var countryId = Provider.of<CountryDropdownService>(context, listen: false)
        .selectedCountryId;

    var stateId = Provider.of<StateDropdownService>(context, listen: false)
        .selectedStateId;
    var cityId =
        Provider.of<CityDropdownService>(context, listen: false).selectedCityId;

    if (stateId == defaultId) {
      showToast(ln.getString(ConstString.youMustSelectAstate), Colors.black);
      return;
    }
    if (countryId == defaultId) {
      showToast(ln.getString(ConstString.youMustSelectAcountry), Colors.black);
      return;
    }
    // if (cityId == defaultId) {
    //   showToast(ln.getString(ConstString.youMustSelectACity), Colors.black);
    //   return;
    // }
    final userId = Provider.of<ProfileService>(context, listen: false)
        .profileDetails
        ?.userDetails
        .id;

    var data = jsonEncode({
      'full_name': name,
      'email': email,
      'phone': phone,
      'state_id': stateId,
      'city_id': cityId,
      'postal_code': zip,
      'country_id': countryId,
      'address': address,
      'shipping_address_name': shippingName,
      'user_id': userId.toString()
    });
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    setLoadingTrue();

    var response = await http.post(Uri.parse(ApiUrl.addShippingUri),
        body: data, headers: header);

    setLoadingFalse();

    if (response.statusCode == 200) {
      debugPrint(response.body.toString());
      debugPrint(data.toString());
      showToast(ln.getString(ConstString.addressSaved), Colors.black);

      Provider.of<ShippingListService>(context, listen: false)
          .fetchAddressList(isFromAddAddressPage: true);

      Navigator.pop(context);
      Provider.of<ProfileService>(context, listen: false)
          .getProfileDetails(context, loadAnyway: true);
    } else {
      showToast(ln.getString(ConstString.somethingWentWrong), Colors.black);
      print('delivery address save failed ${response.body}');
    }
  }

  removeAddress(addressId, context) async {
    var ln = Provider.of<TranslateStringService>(context, listen: false);

    setLoadingTrue();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var response = await http.get(
        Uri.parse('${ApiUrl.removeShippingUri}/$addressId'),
        headers: header);

    setLoadingFalse();

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      Provider.of<ShippingListService>(context, listen: false)
          .fetchAddressList(isFromAddAddressPage: true);

      // pop alert dialogue
      Navigator.pop(context);
    } else {
      showToast(ln.getString(ConstString.somethingWentWrong), Colors.black);
      print('shipping address delete failed${response.body}');
    }
  }
}
