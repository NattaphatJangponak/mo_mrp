// http

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/stockitem.dart';

// po
class HttpService {
  Future<List<StockItem>> fetchWhInList() async {
    final String url = 'http://192.168.1.122:8069/get_list_whin';
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

  Future<List<Map<String, dynamic>>> fetchPoLines(String poName) async {
    final String url = 'http://192.168.1.122:8069/get_list_po';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "jsonrpc": "2.0",
        "params": {"po_name": poName}
      }),
    );

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      final result = jsonMap['result'] as List;
      return result.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load PO lines');
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

  // so

  Future<List<StockItem>> fetchWhOutList() async {
    final String url = 'http://192.168.1.122:8069/get_list_whout';
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
      throw Exception('❌ Failed to load WHOUT');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSoLines(String soName) async {
    final String url = 'http://192.168.1.122:8069/get_list_so';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "jsonrpc": "2.0",
        "params": {"so_name": soName}
      }),
    );

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      final result = jsonMap['result'] as List;
      return result.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load SO lines');
    }
  }

// tranfer
  Future<List<StockItem>> fetchWhTrnList() async {
    final String url = 'http://192.168.1.122:8069/get_list_whtrn';
    final uri = Uri.parse(url);

    final request = http.Request("GET", uri)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      })
      ..body = jsonEncode({}); // ส่ง body ว่างสำหรับ GET request

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);

      if (jsonMap.containsKey('result')) {
        final List<dynamic> resultList = jsonMap['result'];
        return resultList.map((e) => StockItem.fromJson(e)).toList();
      } else {
        throw Exception('⚠️ No "result" key found"');
      }
    } else {
      throw Exception('❌ Failed to load WHTRN');
    }
  }

  Future<List<Map<String, dynamic>>> fetchTrnLines(String trnName) async {
    final String url = 'http://192.168.1.122:8069/get_list_trn';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "jsonrpc": "2.0",
        "params": {"trn_name": trnName}
      }),
    );

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      final result = jsonMap['result'] as List;
      return result.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load TRN lines');
    }
  }
}
