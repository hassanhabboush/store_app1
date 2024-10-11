// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/model/child_category_model.dart';
import 'package:store_app/services/subcategory_service.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:provider/provider.dart';

class ChildCategoryService with ChangeNotifier {
  var childCategoryDropdownList = [];
  var childCategoryDropdownIndexList = [];
  var selectedChildCategory;
  var selectedChildCategoryId;

  setChildCategoryValue(value) {
    selectedChildCategory = value;
    print('selected childcategory $selectedChildCategory');
    notifyListeners();
  }

  setSelectedChildCategoryId(value) {
    selectedChildCategoryId = value;
    print('selected childCategory id $value');
    notifyListeners();
  }

  setDefault() {
    childCategoryDropdownList = [];
    childCategoryDropdownIndexList = [];
    selectedChildCategory = null;
    selectedChildCategoryId = null;
    notifyListeners();
  }

  setDummyValue() {
    childCategoryDropdownList.add(ConstString.selectChildCategory);
    childCategoryDropdownIndexList.add(null);
    selectedChildCategory = ConstString.selectChildCategory;
    selectedChildCategoryId = null;
    notifyListeners();
  }

  setFirstValue() {
    if (childCategoryDropdownList.isEmpty) return;
    selectedChildCategory = childCategoryDropdownList[0];
    selectedChildCategoryId = childCategoryDropdownIndexList[0];
    notifyListeners();
  }

  fetchChildCategory(BuildContext context) async {
    setDefault();

    var selectedChildcategoryId =
        Provider.of<SubCategoryService>(context, listen: false)
            .selectedSubCategoryId;

    var response = await http
        .get(Uri.parse('${ApiUrl.childCategoryUri}/$selectedChildcategoryId'));
    print(response.body);

    setDummyValue();

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = ChildCategoryModel.fromJson(jsonDecode(response.body));

      for (int i = 0; i < data.childCategories.length; i++) {
        childCategoryDropdownList.add(data.childCategories[i].name);
        childCategoryDropdownIndexList.add(data.childCategories[i].id);
      }

      setFirstValue();
    } else {
      //error fetching data
    }
  }
}
