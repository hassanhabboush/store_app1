import 'package:flutter/material.dart';
import 'package:store_app/view/utils/const_strings.dart';

class TicketStatusDropdownService with ChangeNotifier {
  var statusDropdownList = [ConstString.open, ConstString.close];
  var statusDropdownIndexList = [ConstString.open, ConstString.close];
  var selectedstatus = ConstString.open;
  var selectedstatusId = ConstString.open;

  setstatusValue(value) {
    selectedstatus = value;
    notifyListeners();
  }

  setSelectedstatusId(value) {
    selectedstatusId = value;
    notifyListeners();
  }
}
