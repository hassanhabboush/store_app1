// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/dropdown_services/priority_and_department_dropdown_service.dart';
import 'package:store_app/services/ticket_services/support_ticket_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateTicketService with ChangeNotifier {
  bool isLoading = false;

  //create ticket ====>

  createTicket(title, subject, description, BuildContext context) async {
    var ln = Provider.of<TranslateStringService>(context, listen: false);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var priority = Provider.of<PriorityAndDepartmentDropdownService>(context,
            listen: false)
        .selectedPriority;
    var departmentId = Provider.of<PriorityAndDepartmentDropdownService>(
            context,
            listen: false)
        .selectedDepartmentId;

    var data = jsonEncode({
      'title': title,
      'subject': subject,
      'priority': priority,
      'description': description,
      'departments': departmentId.toString()
    });

    var connection = await checkConnection(context);
    if (connection) {
      isLoading = true;
      notifyListeners();
      //if connection is ok
      var response = await http.post(Uri.parse(ApiUrl.createTicketUri),
          headers: header, body: data);
      isLoading = false;
      notifyListeners();

      print(response.statusCode);
      if (response.statusCode == 200) {
        showToast(
            ln.getString(ConstString.ticketCreatedSuccessfully), Colors.black);

        //add ticket to ticket list
        Provider.of<SupportTicketService>(context, listen: false)
            .addNewDataToTicketList(jsonDecode(response.body)['ticket']['id'],
                title, subject, priority, description, 'open');

        //======>
        Navigator.pop(context);
      } else {
        showToast(ln.getString(ConstString.somethingWentWrong), Colors.black);
        print('ticket create failed ${response.body}');
      }
    }
  }
}
