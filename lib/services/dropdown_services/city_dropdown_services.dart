// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_app/model/city_dropdown_model.dart';
import 'package:store_app/services/dropdown_services/country_dropdown_service.dart';
import 'package:store_app/services/dropdown_services/state_dropdown_services.dart';
import 'package:store_app/services/profile_service.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CityDropdownService with ChangeNotifier {
  var citiesDropdownList = [];
  var citiesDropdownIndexList = [];

  dynamic selectedCity = ConstString.selectCity;
  dynamic selectedCityId = defaultId;

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

  setCityDefault() {
    citiesDropdownList = [];
    citiesDropdownIndexList = [];
    selectedCity = ConstString.selectCity;
    selectedCityId = defaultId;

    currentPage = 1;
    notifyListeners();
  }

  setCityValue(value) {
    selectedCity = value;
    print('selected state $selectedCity');
    notifyListeners();
  }

  setSelectedCityId(value) {
    selectedCityId = value ?? defaultId;
    print('selected state id $value');
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

  Future<bool> fetchCity(BuildContext context, {bool isrefresh = false}) async {
    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      //we are make the list empty when the sub category or brand is selected because then the refresh is true
      setCityDefault();

      setCurrentPage(currentPage);
    }

    var selectedStateId =
        Provider.of<StateDropdownService>(context, listen: false)
            .selectedStateId;

    var response = await http.get(
        Uri.parse('${ApiUrl.cityListUri}/$selectedStateId?page=$currentPage'));
    debugPrint(response.body.toString());

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        jsonDecode(response.body)['cities']['data'].isNotEmpty) {
      var data = CityDropdownModel.fromJson(jsonDecode(response.body));
      debugPrint(data.cities?.data.toString());
      for (int i = 0; i < (data.cities?.data ?? []).length; i++) {
        citiesDropdownList.add(data.cities?.data![i].name);
        citiesDropdownIndexList.add(data.cities?.data![i].id);
      }

      set_City(context, data: data);
      notifyListeners();

      currentPage++;
      setCurrentPage(currentPage);

      return true;
    } else {
      //error fetching data

      if (citiesDropdownList.isEmpty) {
        citiesDropdownList.add(ConstString.selectCity);
        citiesDropdownIndexList.add(defaultId);
        selectedCity = ConstString.selectCity;
        selectedCityId = defaultId;
        notifyListeners();
      }

      return false;
    }
  }

  //Set state based on user profile
//==============================>
  setCityBasedOnUserProfile(BuildContext context) {
    var profileProvider =
        Provider.of<ProfileService>(context, listen: false).profileDetails;

    selectedCity =
        profileProvider?.userDetails.city?.name ?? ConstString.selectCity;
    selectedCityId = profileProvider?.userDetails.city?.id ?? defaultId;
    print(citiesDropdownList);
    print(citiesDropdownIndexList);
    print('selected state $selectedCity');
    print('selected state id $selectedCityId');
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   notifyListeners();
    // });
  }

  //==============>
  set_City(BuildContext context, {CityDropdownModel? data}) {
    var profileData =
        Provider.of<ProfileService>(context, listen: false).profileDetails;

    if (profileData != null) {
      var userStateId = Provider.of<ProfileService>(context, listen: false)
              .profileDetails
              ?.userDetails
              .userState
              ?.id ??
          defaultId;

      var selectedStateId =
          Provider.of<StateDropdownService>(context, listen: false)
              .selectedStateId;

      if (userStateId == selectedStateId) {
        //if user selected the country id which is save in his profile
        //only then show state/area based on that

        setCityBasedOnUserProfile(context);
      } else {
        if (data != null) {
          selectedCity = data.cities?.data?[0].name;
          selectedCityId = data.cities?.data?[0].id;
        }
      }
    } else {
      if (data != null) {
        selectedCity = data.cities?.data?[0].name;
        selectedCityId = data.cities?.data?[0].id;
      }
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      notifyListeners();
    });
  }

  // ================>
  // Search
  // ================>

  Future<bool> searchCity(BuildContext context, String searchText,
      {bool isrefresh = false, bool isSearching = false}) async {
    if (isSearching) {
      setCityDefault();
    }

    var selectedStateId =
        Provider.of<StateDropdownService>(context, listen: false)
            .selectedStateId;
    var response = await http
        .get(Uri.parse('${ApiUrl.citySearchUri}/$selectedStateId/$searchText'));
    debugPrint(
        '${ApiUrl.citySearchUri}/$selectedStateId/$searchText'.toString());
    debugPrint(response.body.toString());
    if ((response.statusCode == 200 || response.statusCode == 201) &&
        jsonDecode(response.body)['city']['data'].isNotEmpty) {
      var data = CityDropdownModel.fromJsonSearched(jsonDecode(response.body));
      for (int i = 0; i < (data.cities?.data ?? []).length; i++) {
        citiesDropdownList.add(data.cities?.data?[i].name);
        citiesDropdownIndexList.add(data.cities?.data?[i].id);
      }

      notifyListeners();

      currentPage++;
      setCurrentPage(currentPage);

      return true;
    } else {
      //error fetching data
      citiesDropdownList.add(ConstString.selectCity);
      citiesDropdownIndexList.add(defaultId);
      selectedCity = ConstString.selectCity;
      selectedCityId = defaultId;
      notifyListeners();
      return false;
    }
  }
}
