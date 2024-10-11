import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/model/department_dropdown_model.dart';
import 'package:store_app/services/dropdown_services/country_dropdown_service.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PriorityAndDepartmentDropdownService with ChangeNotifier {
  //priority dropdown
  var priorityDropdownList = ['Low', 'High', 'Medium', 'Urgent'];
  var priorityDropdownIndexList = ['Low', 'High', 'Medium', 'Urgent'];
  var selectedPriority = 'Low';
  var selectedPriorityId = 'Low';

  setPriorityValue(value) {
    selectedPriority = value;
    notifyListeners();
  }

  setSelectedPriorityId(value) {
    selectedPriorityId = value;
    notifyListeners();
  }

  //department dropdown
  List<String> departmentDropdownList = [];
  var departmentDropdownIndexList = [];
  var selectedDepartment;
  var selectedDepartmentId;

  setDepartmentValue(value) {
    selectedDepartment = value;
    notifyListeners();
  }

  setSelectedDepartmentId(value) {
    selectedDepartmentId = value;
    notifyListeners();
  }

  fetchDepartment(BuildContext context) async {
    if (departmentDropdownList.isNotEmpty) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var header = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var response =
        await http.get(Uri.parse(ApiUrl.departmentUri), headers: header);

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['data'].isNotEmpty) {
      var data = DepartmentDropdownModel.fromJson(jsonDecode(response.body));

      for (int i = 0; i < data.data.length; i++) {
        if (data.data[i].status == "1") {
          departmentDropdownList.add(data.data[i].name!);
          departmentDropdownIndexList.add(data.data[i].id);
        }
      }

      selectedDepartment = departmentDropdownList[0];
      selectedDepartmentId = departmentDropdownIndexList[0];

      notifyListeners();
    } else {
      //error fetching data
      departmentDropdownList.add(ConstString.selectDepartment);
      departmentDropdownIndexList.add(defaultId);
      selectedDepartment = ConstString.selectDepartment;
      selectedDepartmentId = defaultId;
      notifyListeners();
    }
  }
}
