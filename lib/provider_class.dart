import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:midterm_nawal_22805/product_model.dart';

class DataClass extends ChangeNotifier {
  List<Products>? post;
  bool loading = false;

  getPostData() async {
    loading = true;
    post = (await getPostApi());
    loading = false;

    notifyListeners(); //isse ui ko pata chalega k variables update horhe (setState cannot be used as it is not a stateful widget, just a class)
  }

  Future<List<Products>> getPostApi() async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['products'];
      List<Products> postList =
          List<Products>.from(data.map((dynamic i) => Products.fromJson(i)));
      return postList;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
