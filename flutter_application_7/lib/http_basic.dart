import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String> fetchData() async {
  try {
    final response =
        await http.get(Uri.parse('https://itpart.net/mobile/api/products.php'));

    if (response.statusCode == 200) {
      String strBody = response.body.toString();
      debugPrint('$strBody');
      return strBody;
      // final jsonObject = json.decode(response.body);
      // return jsonObject['title'];
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to fetch data: $e');
  }
}

class HttpBasic extends StatefulWidget {
  const HttpBasic({super.key});

  @override
  State<HttpBasic> createState() => _HttpBasicState();
}

class _HttpBasicState extends State<HttpBasic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text('HttpBasic Page'),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return Text('${snapshot.data}',
                style: const TextStyle(fontSize: 18));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 18));
          }
          return const Text('No data available');
        },
      ),
    );
  }
}
