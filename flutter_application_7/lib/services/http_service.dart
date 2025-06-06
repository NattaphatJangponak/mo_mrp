// http

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/stockitem.dart';

class HttpService {
  Future<List<StockItem>> fetchWhInList() async {
    final String url = 'http://192.168.1.119:8069/get_list_whin';
    final uri = Uri.parse(url);

    final request = http.Request("GET", uri)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      })
      ..body = jsonEncode({}); // ✅ ส่ง body {} แบบ GET

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);

      if (jsonMap.containsKey('result')) {
        final List<dynamic> resultList = jsonMap['result'];
        return resultList.map((e) => StockItem.fromJson(e)).toList();
      } else {
        throw Exception('⚠️ No "result" key found');
      }
    } else {
      throw Exception('❌ Failed to load WHIN');
    }
  }

  Future<List<Product>> fetchData({required String strUrl}) async {
    debugPrint('url: $strUrl');
    final response = await http.get(Uri.parse(strUrl), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    });

    if (response.statusCode == 200) {
      // List<dynamic> data = jsonDecode(response.body);  // ok
      List data = json.decode(response.body); // ok

      return data
          .map((e) => Product.fromJson(e))
          .toList(); // use method in class
    } else {
      debugPrint('failed loading');
      throw Exception('Failed to load data!');
    }
  }

  // fetch 1 record
  Future<Product> fetchRecord({required String strUrl}) async {
    debugPrint('url: $strUrl');
    final response = await http.get(Uri.parse(strUrl), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    });

    if (response.statusCode == 200) {
      debugPrint('${response.body.toString()}');
      return Product.fromJson(jsonDecode(response.body));
    } else {
      debugPrint('failed loading data!');
      throw Exception('Failed to load data!');
    }
  }
}
