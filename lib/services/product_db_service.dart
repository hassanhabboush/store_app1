// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class ProductDbService {
  static Database? _database;

  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'product_db');
    Database? database;
    try {
      database = await openDatabase(path, version: 1, onCreate: _dbOnCreate);
    } catch (e) {
      await _database?.execute("DROP TABLE IF EXISTS cart_table");
      await _database?.execute("DROP TABLE IF EXISTS fav_table");
      database = await openDatabase(path, version: 1, onCreate: _dbOnCreate);
    }
    return database;
  }

  _dbOnCreate(Database database, int version) async {
    await database.execute(
        "CREATE TABLE cart_table(id INTEGER PRIMARY KEY AUTOINCREMENT, productId TEXT, title TEXT, thumbnail TEXT, discountPrice REAL,oldPrice REAL,priceWithAttr REAL, qty INTEGER, color TEXT,size TEXT,category INTEGER,subcategory INTEGER,childCategory INTEGER,attributes TEXT,variantId INTEGER, tax_options_sum_rate TEXT)");

    await database.execute(
        "CREATE TABLE fav_table(id INTEGER PRIMARY KEY AUTOINCREMENT, productId TEXT, title TEXT, thumbnail TEXT, discountPrice REAL,oldPrice REAL,priceWithAttr REAL, qty INTEGER, color TEXT,size TEXT,category INTEGER,subcategory INTEGER,childCategory INTEGER,attributes TEXT,variantId INTEGER, tax_options_sum_rate TEXT)");
  }

  Future<Database> get getdatabase async {
    if (_database != null) {
      //if the database already exists
      return _database!;
    } else {
      //else create the database and return it
      _database = await setDatabase();
      return _database!;
    }
  }

  checkIfAddedtoCart(String title, int productId) async {
    var connection = await getdatabase;
    var data = await connection.rawQuery(
        "SELECT * FROM cart_table WHERE title=? and productId=?",
        [title, productId]);
    if (data.isNotEmpty) {
      //if not empty then it is added to cart
      return true;
    } else {
      return false;
    }
  }

  removeFromCart(productId, title, attributes, BuildContext context) async {
    var connection = await getdatabase;

    var ln = Provider.of<TranslateStringService>(context, listen: false);

    await connection.rawDelete(
        "DELETE FROM cart_table WHERE productId=? and title=? and attributes=?",
        [
          productId,
          title,
          (attributes is Map ? jsonEncode(attributes) : attributes)
        ]);

    print('removed from cart');

    showSnackBar(
        context, ln.getString(ConstString.removedFromCart), primaryColor);
  }

  allCartProducts() async {
    var connection = await getdatabase;
    return await connection.query('cart_table');
  }

  //single product
  getSingleProduct(String productId, String title, attributes,
      {bool ignoreAttribute = false}) async {
    var connection = await getdatabase;
    Future<List<Map<String, Object?>>> prod;

    if (ignoreAttribute) {
      prod = connection.rawQuery(
          "SELECT * FROM cart_table WHERE productId=? and title =?",
          [productId, title]);
    } else {
      prod = connection.rawQuery(
          "SELECT * FROM cart_table WHERE productId=? and title =? and attributes =?",
          [
            productId,
            title,
            (attributes is Map ? jsonEncode(attributes) : attributes)
          ]);
    }

    return prod;
  }

  Future<bool> updateQtandPrice(
      String productId, String title, int qty, attributes, BuildContext context,
      {bool ignoreAttribute = false}) async {
    var connection = await getdatabase;

    if (ignoreAttribute) {
      await connection.rawUpdate(
          "UPDATE cart_table SET qty=? WHERE productId=? and title =?",
          [qty, productId, title]);
    } else {
      await connection.rawUpdate(
          "UPDATE cart_table SET qty=? WHERE productId=? and title =? and attributes =?",
          [
            qty,
            productId,
            title,
            (attributes is Map ? jsonEncode(attributes) : attributes)
          ]);
    }

    return true;
  }

  emptyCartTable() async {
    var connection = await getdatabase;
    connection.rawQuery("DELETE FROM cart_table");
    return true;
  }

//Favourite table functionalities ======================>

  allfavProducts() async {
    var connection = await getdatabase;
    return await connection.query('fav_table');
  }
}
