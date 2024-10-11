// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/services/dropdown_services/city_dropdown_services.dart';
import 'package:store_app/services/dropdown_services/country_dropdown_service.dart';
import 'package:store_app/services/dropdown_services/state_dropdown_services.dart';
import 'package:store_app/services/profile_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view/utils/constant_colors.dart';

class ProfileEditService with ChangeNotifier {
  XFile? imageFile;

  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  final ImagePicker _picker = ImagePicker();
  Future pickImage() async {
    imageFile = await _picker.pickImage(source: ImageSource.gallery);
    notifyListeners();
    if (imageFile != null) {
      return imageFile;
    } else {
      return null;
    }
  }

  setDefault() {
    imageFile = null;
    notifyListeners();
  }

  String countryCode = 'BD';

  setCountryCode(code) {
    countryCode = code;
    notifyListeners();
  }

  updateProfile(
    context, {
    required name,
    required email,
    required phone,
    required zip,
    required address,
  }) async {
    try {
      var ln = Provider.of<TranslateStringService>(context, listen: false);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var countryId =
          Provider.of<CountryDropdownService>(context, listen: false)
              .selectedCountryId;

      var stateId = Provider.of<StateDropdownService>(context, listen: false)
          .selectedStateId;
      var cityId = Provider.of<CityDropdownService>(context, listen: false)
          .selectedCityId;

      setLoadingTrue();
      if (ApiUrl.siteUrl.toLowerCase().contains("www.hexfashion.xyz")) {
        await Future.delayed(const Duration(seconds: 2));
        showToast("This feature is turned off for demo app", blackColor);
        setLoadingFalse();
        return false;
      }

      var dio = Dio();
      // dio.options.headers['Accept'] = 'application/json';
      dio.options.headers['Content-Type'] = 'multipart/form-data';
      dio.options.headers["Authorization"] = "Bearer $token";

      FormData formData;

      formData = FormData.fromMap({
        'full_name': name,
        'email': email,
        'mobile': phone,
        'file': imageFile != null
            ? await MultipartFile.fromFile(imageFile!.path,
                filename: 'profileImage$name$zip${imageFile!.path}.jpg')
            : null,
        'country_id': countryId.toString(),
        'state_id': stateId.toString(),
        'address': address,
        'city_id': cityId.toString(),
        'postal_code': zip,
        'user_type': 'api'
      });

      var response = await dio.post(ApiUrl.updateProfileUri,
          data: formData,
          options: Options(
            validateStatus: (status) => true,
          ));
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        setLoadingFalse();
        showToast(
            ln.getString(ConstString.profileUpdatedSuccessfully), Colors.black);
        print(response.data);

        //re fetch profile data again
        await Provider.of<ProfileService>(context, listen: false)
            .getProfileDetails(context, loadAnyway: true);

        // Future.delayed(const Duration(microseconds: 1600), () {
        Navigator.pop(context);
        // });

        return true;
      } else {
        print('error updating profile' + response.data);
        showToast(ln.getString(ConstString.somethingWentWrong), Colors.black);
        return false;
      }
    } finally {
      setLoadingFalse();
    }
  }
}
