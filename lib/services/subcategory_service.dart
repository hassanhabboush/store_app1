// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/model/subcategory_model.dart';
import 'package:store_app/services/category_service.dart';
import 'package:store_app/services/child_category_service.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:provider/provider.dart';

class SubCategoryService with ChangeNotifier {
  var subCategoryDropdownList = [];
  var subCategoryDropdownIndexList = [];
  var selectedSubCategory;
  var selectedSubCategoryId;

  setSubCategoryValue(value) {
    selectedSubCategory = value;
    print('selected subcategory $selectedSubCategory');
    notifyListeners();
  }

  setSelectedSubCategoryId(value) {
    selectedSubCategoryId = value;
    print('selected subCategory id $value');
    notifyListeners();
  }

  setDefault() {
    subCategoryDropdownList = [];
    subCategoryDropdownIndexList = [];
    selectedSubCategory = null;
    selectedSubCategoryId = null;
    notifyListeners();
  }

  setDummyValue() {
    subCategoryDropdownList.add(ConstString.selectSubCategory);
    subCategoryDropdownIndexList.add(null);
    selectedSubCategory = ConstString.selectSubCategory;
    selectedSubCategoryId = null;
    notifyListeners();
  }

  setFirstValue() {
    if (subCategoryDropdownList.isEmpty) return;
    selectedSubCategory = subCategoryDropdownList[0];
    selectedSubCategoryId = subCategoryDropdownIndexList[0];

    notifyListeners();
  }

  fetchSubCategory(BuildContext context) async {
    setDefault();
    //
    var selectedCategoryId =
        Provider.of<CategoryService>(context, listen: false).selectedCategoryId;

    var response = await http
        .get(Uri.parse('${ApiUrl.subcategoryUri}/$selectedCategoryId'));
    print(response.body);

    setDummyValue();

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = SubCategoryModel.fromJson(jsonDecode(response.body));

      for (int i = 0; i < data.subcategories.length; i++) {
        subCategoryDropdownList.add(data.subcategories[i].name);
        subCategoryDropdownIndexList.add(data.subcategories[i].id);
      }

      setFirstValue();

      Provider.of<ChildCategoryService>(context, listen: false)
          .fetchChildCategory(context);
    } else {
      //error fetching data
    }
  }
}
