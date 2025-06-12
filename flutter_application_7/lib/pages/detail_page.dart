import 'package:flutter/material.dart';
import 'package:flutter_application_7/pages/lot_page.dart';
import 'package:flutter_application_7/pages/scanner_page.dart';
import 'package:flutter_application_7/pages/sn_page.dart';

import 'package:flutter_application_7/dialogs/dialog_add_so.dart';
import 'package:flutter_application_7/dialogs/dialog_add_po.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final String? docCode;
  final String mode;
  const DetailPage(
      {super.key, required this.data, this.docCode, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    data['docCode'] ??
                        '-', // ✅ ใช้ data['docCode'] แทน widget.docCode
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data['name'] ?? 'No name',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${data['qty'] ?? '-'}'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilledButton(
                  onPressed: () {
                    if (mode == 'in') {
                      print(mode);
                      showAddLotPoDialog(context, data['docCode']);
                    } else if (mode == 'out') {
                      print(mode);
                      showAddLotSoDialog(
                        context,
                        data['docCode'],
                        data['name'],
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add Lot'),
                ),
                FilledButton(
                  onPressed: () {
                    if (mode == 'in') {
                      print(mode);
                      showAddBarPoDialog(context, data['docCode']);
                    } else if (mode == 'out') {
                      print(mode);
                      showAddBarSoDialog(context, data['docCode']);
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add Barcode'),
                ),

                FilledButton(
                  onPressed: () {
                    if (mode == 'in') {
                      print(mode);
                      showAddSnPoDialog(context, data['docCode'], data['name']);
                    } else if (mode == 'out') {
                      print(mode);
                      showAddSnSoDialog(context, data['docCode'], data['name']);
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add S/N'),
                ),
                // FilledButton(
                //   onPressed: () => showAddBarPoDialog(context, data['docCode']),
                //   style: FilledButton.styleFrom(
                //     backgroundColor: Colors.blue,
                //     foregroundColor: Colors.white,
                //   ),
                //   child: const Text('Add Bar'),
                // ),

                // FilledButton(
                //   onPressed: () =>
                //       showAddSnPoDialog(context, data['docCode'], data['name']),
                //   style: FilledButton.styleFrom(
                //     backgroundColor: Colors.orange,
                //     foregroundColor: Colors.white,
                //   ),
                //   child: const Text('S/N'),
                // ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LotPage()),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Lot Summary'),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScannerPage()),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Barcode Summary'),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SnPage()),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('S/N Summary'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_application_7/data.dart';
// import 'package:flutter_application_7/pages/lot_page.dart';
// import 'package:flutter_application_7/pages/scanner_page.dart';
// import 'package:flutter_application_7/pages/sn_page.dart';

// Future fetchData(String id) async {
//   // implement fetch data
//   await Future.delayed(const Duration(seconds: 2));
//   return products.firstWhere((product) => product['id'] == int.parse(id));
// }

// class DetailPage extends StatefulWidget {

//   final Map<String, dynamic> data;

//   const DetailPage({super.key, required this.data});

//   @override
//   State<DetailPage> createState() => _DetailPageState();
// }

// class _DetailPageState extends State<DetailPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Detail'),
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(8.0),
//           child: FutureBuilder(
//               future: fetchData("${widget.productId}"),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (snapshot.hasData) {
//                   final data = snapshot.data;
//                   return Column(
//                     spacing: 16.0,
//                     children: [
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: Text(data['title'],
//                             style: const TextStyle(
//                                 fontSize: 24, fontWeight: FontWeight.bold)),
//                       ),
//                       Image.network(data['imageUrl']),
//                       Align(
//                           alignment: Alignment.topLeft,
//                           child: Text(data['description'])),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           FilledButton(
//                             onPressed: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => LotPage(),
//                                   ));
//                             },
//                             style: FilledButton.styleFrom(
//                               backgroundColor: Colors.purple,
//                               foregroundColor: Colors.white,
//                             ),
//                             child: const Text('Lot'),
//                           ),
//                           FilledButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => ScannerPage(),
//                                     ));
//                               },
//                               style: FilledButton.styleFrom(
//                                 backgroundColor: Colors.blue,
//                                 foregroundColor: Colors.white,
//                               ),
//                               child: const Text('Barcode')),
//                           FilledButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => SnPage(),
//                                     ));
//                               },
//                               style: FilledButton.styleFrom(
//                                 backgroundColor: Colors.orange,
//                                 foregroundColor: Colors.white,
//                               ),
//                               child: const Text('S/N')),
//                         ],
//                       ),
//                     ],
//                   );
//                 } else {
//                   return const Center(child: Text('No data available'));
//                 }
//               }),
//         ));
//   }
// }
