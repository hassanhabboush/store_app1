import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/model/ticket_messages_model.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/api_url.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupportMessagesService with ChangeNotifier {
  List messagesList = [];

  bool isloading = false;
  bool sendLoading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  setSendLoadingTrue() {
    sendLoading = true;
    notifyListeners();
  }

  setSendLoadingFalse() {
    sendLoading = false;
    notifyListeners();
  }

  // final ImagePicker _picker = ImagePicker();

  final ImagePicker _picker = ImagePicker();
  Future pickImage() async {
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      return imageFile;
    } else {
      return null;
    }
  }

  fetchMessages(ticketId, BuildContext context) async {
    var connection = await checkConnection(context);
    if (!connection) return;
    messagesList = [];

    setLoadingTrue();

    //if connection is ok

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json"
      "Authorization": "Bearer $token",
    };
    var response = await http.get(
        Uri.parse('${ApiUrl.ticketMessageUri}/$ticketId'),
        headers: header);
    setLoadingFalse();

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['all_messages'].isNotEmpty) {
      var data = TicketMessagesModel.fromJson(jsonDecode(response.body));

      setMessageList(data.allMessages);

      notifyListeners();
    } else {
      //Something went wrong
      print(response.body);
    }
  }

  setMessageList(dataList) {
    for (int i = 0; i < dataList.length; i++) {
      messagesList.add({
        'id': dataList[i].id,
        'message': dataList[i].message,
        'attachment': dataList[i].attachment,
        'type': dataList[i].type,
        'imagePicked':
            false //check if this image is just got picked from device in that case we will show it from device location
      });
    }
    notifyListeners();
  }

//Send new message ======>

  sendMessage(
      {required ticketId,
      required message,
      required filePath,
      required priority,
      required description,
      required departmentId,
      required BuildContext context}) async {
    var ln = Provider.of<TranslateStringService>(context, listen: false);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = "Bearer $token";
    FormData formData;

    formData = FormData.fromMap({
      'user_type': 'customer',
      'message': message,
      'priority': priority,
      'description': description,
      'departments': departmentId,
      'file': filePath != null
          ? await MultipartFile.fromFile(filePath, filename: 'ticket$filePath')
          : null
    });

    var connection = await checkConnection(context);
    if (connection) {
      setSendLoadingTrue();
      //if connection is ok

      var response = await dio.post(
        '${ApiUrl.ticketMessageSendUri}/$ticketId',
        data: formData,
      );
      setSendLoadingFalse();

      if (response.statusCode == 200) {
        print(response.data);
        addNewMessage(message, filePath);
        return true;
      } else {
        showToast(ln.getString(ConstString.somethingWentWrong), Colors.black);
        print(response.data);
        return false;
      }
    } else {
      showToast(ln.getString(ConstString.plzCheckInternet), Colors.black);
      return false;
    }
  }

  addNewMessage(newMessage, filePath) {
    messagesList.add({
      'id': '',
      'message': newMessage,
      'attachment': filePath,
      'type': 'customer',
      'imagePicked':
          true //check if this image is just got picked from device in that case we will show it from device location
    });
    notifyListeners();
  }
}
