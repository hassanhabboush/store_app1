// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:store_app/model/add_to_cart_model.dart';
import 'package:store_app/services/product_db_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class FavouriteService with ChangeNotifier {
  int favProductsLength = 0;

  var favItemList = [];

  fetchFavProducts() async {
    favItemList = await ProductDbService().allfavProducts();
    favProductsLength = favItemList.length;
    notifyListeners();
  }

  Future<bool> addOrRemoveFavourite(BuildContext context,
      {required productId,
      required String title,
      required String thumbnail,
      required discountPrice,
      required oldPrice,
      required int qty,
      required String? color,
      required String? size,
      required priceWithAttr,
      required category,
      required subcategory,
      required childCategory,
      required attributes,
      required taxOSR,
      required variantId}) async {
    var ln = Provider.of<TranslateStringService>(context, listen: false);

    var connection = await ProductDbService().getdatabase;
    var favaudio = await connection.rawQuery(
        "SELECT * FROM fav_table WHERE title=? and productId=?",
        [title, productId]);
    if (favaudio.isEmpty) {
      //if already not added to favourite

      var cartObj =
          AddtocartModel(); //this model is enough for us, favmodel is not necessary
      cartObj.productId = productId;
      cartObj.title = title;
      cartObj.thumbnail = thumbnail;
      cartObj.discountPrice = discountPrice;
      cartObj.oldPrice = oldPrice;
      cartObj.qty = qty;
      cartObj.priceWithAttr = priceWithAttr;
      cartObj.color = color;
      cartObj.size = size;
      cartObj.category = category;
      cartObj.subcategory = subcategory;
      cartObj.childCategory = childCategory;
      cartObj.attributes = attributes;
      cartObj.variantId = variantId;
      cartObj.taxOSR = taxOSR?.toString() ?? "";

      await connection.insert('fav_table', cartObj.cartMap());
      print('added to favourite');

      showToast(ln.getString(ConstString.addedToFav), Colors.black);

      return true;
    } else {
      // else already added to favourite. so remove it

      removeFromFavourite(productId, title, context);

      return false;
    }
  }

  // ======>
  // remove from favourite
  removeFromFavourite(productId, title, BuildContext context) async {
    var ln = Provider.of<TranslateStringService>(context, listen: false);
    var connection = await ProductDbService().getdatabase;

    await connection.rawDelete(
        "DELETE FROM fav_table WHERE productId=? and title=?",
        [productId, title]);
    fetchFavProducts();

    showToast(ln.getString(ConstString.removedFromFav), Colors.black);
  }

  //check if added to favourite then change fav button color accordingly
  Future<bool> checkFavourite(String title, int id) async {
    var connection = await ProductDbService().getdatabase;
    var favaudio = await connection.rawQuery(
        "SELECT * FROM fav_table WHERE title=? and productId=?", [title, id]);
    if (favaudio.isNotEmpty) {
      //if not empty then it is added to favourite
      return true;
    } else {
      return false;
    }
  }

  //product number
  fetchFavProductLength() async {
    List products = await ProductDbService().allfavProducts();
    favProductsLength = products.length;
    notifyListeners();
  }
}
