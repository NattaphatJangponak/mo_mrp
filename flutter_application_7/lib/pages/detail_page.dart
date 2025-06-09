import 'package:flutter/material.dart';
import 'package:flutter_application_7/pages/lot_page.dart';
import 'package:flutter_application_7/pages/scanner_page.dart';
import 'package:flutter_application_7/pages/sn_page.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailPage({super.key, required this.data});

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LotPage()),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Lot'),
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
                  child: const Text('Barcode'),
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
                  child: const Text('S/N'),
                ),
              ],
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
