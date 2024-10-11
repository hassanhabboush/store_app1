// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/model/shipping_cost_model.dart';
import 'package:store_app/services/auth_services/login_service.dart';
import 'package:store_app/services/auth_services/signup_service.dart';
import 'package:store_app/services/cart_services/cart_service.dart';
import 'package:store_app/services/cart_services/coupon_service.dart';
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

import '../product_db_service.dart';

class DeliveryAddressService with ChangeNotifier {
  Map enteredDeliveryAddress = {};

  ShippingCostModel? shippingCostDetails;
  bool hasError = false;

  late int selectedShipId;
  var selectedShipName = '';
  num selectedShipCost = 0;
  int defaultShipId = 0;
  var defaultShipName = '';
  List productTaxes = [];

  num vatAmount = 0.0;
  num pTax = 0.0;
  dynamic vatPercentage = 0;

  int selectedShippingIndex = -1;

  bool createAccountWithDeliveryDetails = false;

  setCreateAccountStatus(bool status) {
    createAccountWithDeliveryDetails = status;
    notifyListeners();
  }

  setPass(v) {
    var oldAddress = enteredDeliveryAddress;

    oldAddress["pass"] = v;

    enteredDeliveryAddress = oldAddress;
    notifyListeners();

    print('entered delivery address $enteredDeliveryAddress');
  }

  setSelectedShipIndex(value) {
    debugPrint("shipping index is $value".toString());
    selectedShippingIndex = value;
    notifyListeners();
  }

  setDefault() {
    selectedShipId = defaultShipId;
    selectedShipName = defaultShipName;
    selectedShipCost = 0;
    hasError = false;
    notifyListeners();
  }

  cleatDeliveryAddress() {
    shippingCostDetails = null;
    pTax = 0.0;
    productTaxes = [];
    enteredDeliveryAddress = {};
    selectedShipCost = 0.0;
    selectedShippingIndex = 0;
    selectedShipName = '-';
  }

  setVatAndincreaseTotal(newVatPercent, BuildContext context) async {
    pTax = await calculateProductTaxes(context, productTaxes) ?? 0;
    debugPrint("product tax is $pTax".toString());

    var oldVat = vatAmount;
    vatAmount = (shippingCostDetails?.tax ?? 0) + pTax;

    print('set vat fun ran');

    Provider.of<CartService>(context, listen: false)
        .increaseTotal(oldVat, vatAmount);

    notifyListeners();
  }

  calculateProductTaxes(BuildContext context, List productTaxes) async {
    if (productTaxes.isEmpty) {
      return 0;
    }
    List products = await ProductDbService().allCartProducts();

    num totalTax = 0;
    if (products.isNotEmpty) {
      for (var ele in productTaxes) {
        for (int i = 0; i < products.length; i++) {
          if (products[i]["productId"].toString() ==
              ele["product_id"].toString()) {
            totalTax =
                totalTax + (((ele["tax_amount"] ?? 0)) * products[i]["qty"]);
            break;
          }
        }
      }
    } else {
      totalTax = 0;
    }
    return totalTax;
  }

  calculateVatAmountOnly(BuildContext context) {
    var subtotal = Provider.of<CartService>(context, listen: false).subTotal;
    vatAmount = (subtotal * vatPercentage) / 100;
    notifyListeners();
  }

  setShipIdAndCosts(shipId, shipCost, shipName, BuildContext context) {
    var oldShipCost = selectedShipCost;
    selectedShipId = shipId ?? 0;
    selectedShipName = shipName ?? '-';
    selectedShipCost = shipCost ?? 0;
    notifyListeners();
    debugPrint('selected shipping id $selectedShipId');
    debugPrint('selected shipping cost $selectedShipCost');

    Provider.of<CartService>(context, listen: false)
        .increaseTotal(oldShipCost, selectedShipCost);
  }

  bool isLoading = false;
  setLoadingTrue() {
    isLoading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isLoading = false;
    notifyListeners();
  }

  setShipCostDefault() {
    shippingCostDetails = null;
    hasError = false;
    notifyListeners();
  }

//fetch country shipping cost ======>
  Future<bool> fetchCountryStateShippingCost(BuildContext context) async {
    setLoadingTrue();
    setShipCostDefault();

    var countryId = Provider.of<CountryDropdownService>(context, listen: false)
        .selectedCountryId;
    var stateId = Provider.of<StateDropdownService>(context, listen: false)
        .selectedStateId;
    var cityId =
        Provider.of<CityDropdownService>(context, listen: false).selectedCityId;

    List products = await ProductDbService().allCartProducts();
    List productIds = [];
    debugPrint(products.toString());
    for (var element in products) {
      productIds.add(element["productId"].toString());
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var header = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var body = {
      'country': countryId.toString(),
      'state': stateId.toString(),
      'city': cityId.toString(),
      "product_ids": productIds.toString(),
    };
    debugPrint(body.toString());

    var response = await http.post(Uri.parse(ApiUrl.shippingCostUri),
        headers: header, body: body);

    setLoadingFalse();

    if (response.statusCode == 200) {
      var data = ShippingCostModel.fromJson(jsonDecode(response.body));

      shippingCostDetails = data;
      debugPrint("potome ashce".toString());
      productTaxes = data.productTaxes;

      try {
        if (data.defaultShippingOptions?.options?.shippingMethodId != null) {
          setShipIdAndCosts(
              data.defaultShippingOptions?.options?.shippingMethodId ??
                  data.shippingOptions.first.id ??
                  0,
              data.defaultShippingOptions?.options?.cost ??
                  data.shippingOptions.first.options?.cost,
              data.defaultShippingOptions?.name ??
                  data.shippingOptions.first.name,
              context);

          setSelectedShipIndex(data.shippingOptions.indexWhere((element) =>
              element.id.toString() ==
              data.defaultShippingOptions?.options?.shippingMethodId));
        } else if (data.shippingOptions.isNotEmpty) {
          setSelectedShipIndex(0);
          setShipIdAndCosts(
              data.defaultShippingOptions?.options?.shippingMethodId ??
                  data.shippingOptions[0].id ??
                  0,
              data.defaultShippingOptions?.options?.cost ??
                  data.shippingOptions[0].options?.cost,
              data.defaultShippingOptions?.name ?? data.shippingOptions[0].name,
              context);
        }
      } catch (e) {
        setShipIdAndCosts(0, 0, '', context);
      }

      defaultShipId =
          data.defaultShippingOptions?.options?.shippingMethodId ?? 0;
      defaultShipName = data.defaultShippingOptions?.name ?? '';
      debugPrint(response.body.toString());
      debugPrint("poreo asce".toString());

      await setVatAndincreaseTotal(data.tax?.toDouble() ?? 0, context);

      notifyListeners();

      return true;
    } else {
      //error fetching data
      hasError = true;
      notifyListeners();
      return false;
    }
  }

  checkIfCouponNeed(shippingCoupon, BuildContext context) {
    var appliedCoupon =
        Provider.of<CouponService>(context, listen: false).appliedCoupon;
    if (appliedCoupon == null && shippingCoupon != null) {
      showToast('Coupon is needed', Colors.black);
      return true;
    } else if (appliedCoupon != null && shippingCoupon != null) {
      //check if applied coupon matches the shipping coupon
      if (appliedCoupon != shippingCoupon) {
        showToast(
            'You applied a coupon which is not eligible for this shipping',
            Colors.black);
        return true;
      }
    } else {
      return false;
    }
  }

  Future<bool> registerUsingDeliveryAddress(BuildContext context) async {
    if (createAccountWithDeliveryDetails == false) return false;

    var ln = Provider.of<TranslateStringService>(context, listen: false);

    if (enteredDeliveryAddress["pass"] == null) {
      showToast(ln.getString(ConstString.enterPass), Colors.black);
      return false;
    }
    if (enteredDeliveryAddress["pass"] != null) {
      if (enteredDeliveryAddress["pass"].length < 6) {
        showToast(ln.getString(ConstString.passMustBeSix), Colors.black);
        return false;
      }
    }

    var res =
        await Provider.of<SignupService>(context, listen: false).signup(context,
            userName: enteredDeliveryAddress['name'],
            password: enteredDeliveryAddress['pass'],
            fullName: enteredDeliveryAddress['name'],
            email: enteredDeliveryAddress['email'],
            mobile: enteredDeliveryAddress['phone'],
            // cityName: enteredDeliveryAddress['city'],
            zipCode: enteredDeliveryAddress['zipCode'],
            isFromDeliveryAddressPage: true);

    if (res == true) {
      await Provider.of<LoginService>(context, listen: false).login(
          enteredDeliveryAddress['email'],
          enteredDeliveryAddress['pass'],
          context,
          true,
          isFromCheckout: true);

      Provider.of<ProfileService>(context, listen: false).fetchData(context);
    }
    return res;
  }
}
