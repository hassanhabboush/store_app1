import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/model/campaign_list_model.dart';
import 'package:store_app/model/campaign_products_model.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/view/utils/api_url.dart';

class CampaignService with ChangeNotifier {
  List<CampaignListItem> campaignList = [];
  DateTime? endDate;

  fetchCampaignList(BuildContext context) async {
    if (campaignList.isNotEmpty) return;

    var connection = await checkConnection(context);
    if (!connection) return;

    var response = await http.get(Uri.parse(ApiUrl.campaignListUri));

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body.toString());
      var data = CampaignListModel.fromJson(jsonDecode(response.body));
      campaignList = data.data;
      notifyListeners();
    }
  }

  // =================>
  // Products of campaign
  // =================>

  List<CampaignSingleProduct> productList = [];

  bool isLoading = false;

  setLoadingStatus(bool status) {
    isLoading = status;
    notifyListeners();
  }

  fetchCampaignProducts(BuildContext context, id) async {
    productList = [];

    var connection = await checkConnection(context);
    if (!connection) return;

    setLoadingStatus(true);

    var response =
        await http.get(Uri.parse('${ApiUrl.campaignProductsUri}/$id'));

    setLoadingStatus(false);

    if (response.statusCode == 200) {
      var data = CampaignProductsModel.fromJson(jsonDecode(response.body));
      productList = data.products;
      endDate = data.campaignInfo?.endDate;
      debugPrint("End date is $endDate".toString());
      debugPrint("'${ApiUrl.campaignProductsUri}/$id'".toString());
      debugPrint(
          "End campaign info is ${data.campaignInfo?.toJson()}.campaignInfo"
              .toString());

      notifyListeners();
    }
  }
}
