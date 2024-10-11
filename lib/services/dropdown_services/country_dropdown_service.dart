import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/model/dropdown_models/country_dropdown_model.dart';
import 'package:store_app/services/dropdown_services/city_dropdown_services.dart';
import 'package:store_app/services/dropdown_services/state_dropdown_services.dart';
import 'package:store_app/services/profile_service.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:provider/provider.dart';

var defaultId = '0';

class CountryDropdownService with ChangeNotifier {
  var countryDropdownList = [];
  var countryDropdownIndexList = [];
  dynamic selectedCountry = ConstString.selectCountry;
  dynamic selectedCountryId = defaultId;

  bool isLoading = false;
  late int totalPages;

  int currentPage = 1;

  setCurrentPage(newValue) {
    currentPage = newValue;
    notifyListeners();
  }

  setTotalPage(newPageNumber) {
    totalPages = newPageNumber;
    notifyListeners();
  }

  setCountryValue(value) {
    selectedCountry = value;
    print('selected country $selectedCountry');
    notifyListeners();
  }

  setSelectedCountryId(value) {
    selectedCountryId = value ?? defaultId;
    print('selected country id $value');
    notifyListeners();
  }

  setLoadingTrue() {
    isLoading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isLoading = false;
    notifyListeners();
  }

  setDefault({context}) {
    countryDropdownList = [];
    countryDropdownIndexList = [];
    selectedCountry = ConstString.selectCountry;
    currentPage = 1;
    selectedCountryId = defaultId;
    if (context != null) {
      Provider.of<StateDropdownService>(context, listen: false)
          .setStateDefault();
      Provider.of<CityDropdownService>(context, listen: false).setCityDefault();
    }
    notifyListeners();
  }

  Future<bool> fetchCountries(BuildContext context,
      {bool isrefresh = false}) async {
    if (countryDropdownList.isNotEmpty) return false;

    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      //we are make the list empty when the sub category or brand is selected because then the refresh is true
      setDefault();

      setCurrentPage(1);
    }

    if (countryDropdownList.isEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setLoadingTrue();
      });
      var response = await http
          .get(Uri.parse('${ApiUrl.countryListUri}?page=$currentPage'));

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          jsonDecode(response.body)['countries']['data'].isNotEmpty) {
        var data = CountryDropdownModel.fromJson(jsonDecode(response.body));
        for (int i = 0; i < data.countries.data.length; i++) {
          countryDropdownList.add(data.countries.data[i].name);
          countryDropdownIndexList.add(data.countries.data[i].id);
        }

        setCountry(context, data: data);

        notifyListeners();

        currentPage++;
        setCurrentPage(currentPage);
        return true;
      } else {
        //error fetching data
        countryDropdownList.add(ConstString.selectCountry);
        countryDropdownIndexList.add(defaultId);
        selectedCountry = ConstString.selectCountry;
        selectedCountryId = defaultId;
        notifyListeners();

        return false;
      }
    } else {
      //country list already loaded from api
      setCountry(context);

      return false;
    }
  }

  //Set country based on user profile
//==============================>

  setCountryBasedOnUserProfile(BuildContext context) {
    selectedCountry = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.userDetails
            .userCountry
            ?.name ??
        ConstString.selectCountry;
    selectedCountryId = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.userDetails
            .userCountry
            ?.id ??
        defaultId;

    Future.delayed(const Duration(milliseconds: 500), () {
      notifyListeners();
    });
  }

  setCountry(BuildContext context, {CountryDropdownModel? data}) {
    var profileData =
        Provider.of<ProfileService>(context, listen: false).profileDetails;
    //if profile of user loaded then show selected dropdown data based on the user profile
    if (profileData != null && profileData.userDetails.country != null) {
      setCountryBasedOnUserProfile(context);
    } else {
      if (data != null) {
        selectedCountry = data.countries.data[0].name;
        selectedCountryId = data.countries.data[0].id;
      }
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      notifyListeners();
    });
  }

  // ================>
  // Search country
  // ================>

  Future<bool> searchCountry(BuildContext context, String searchText,
      {bool isrefresh = false, bool isSearching = false}) async {
    if (isSearching) {
      setDefault();
    }

    var response =
        await http.get(Uri.parse('${ApiUrl.countrySearchUri}/$searchText'));

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        jsonDecode(response.body)['countries']['data'].isNotEmpty) {
      var data = CountryDropdownModel.fromJson(jsonDecode(response.body));
      for (int i = 0; i < data.countries.data.length; i++) {
        countryDropdownList.add(data.countries.data[i].name);
        countryDropdownIndexList.add(data.countries.data[i].id);
      }

      notifyListeners();

      currentPage++;
      setCurrentPage(currentPage);
      return true;
    } else {
      //error fetching data
      if (countryDropdownList.isEmpty) {
        countryDropdownList.add(ConstString.selectCountry);
        countryDropdownIndexList.add(defaultId);
        selectedCountry = ConstString.selectCountry;
        selectedCountryId = defaultId;
        notifyListeners();
      }

      return false;
    }
  }
}
