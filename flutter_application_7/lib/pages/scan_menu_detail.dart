import 'package:flutter/material.dart';
import 'package:flutter_application_7/services/http_service.dart';
import 'package:flutter_application_7/models/stockitem.dart';
import 'package:flutter_application_7/pages/scanner/mobile_scanner_simple.dart';
import 'home_page.dart';

class ScanMenuDetailPage extends StatefulWidget {
  final String mode;

  const ScanMenuDetailPage({super.key, required this.mode});

  @override
  State<ScanMenuDetailPage> createState() => _ScanMenuDetailPageState();
}

class _ScanMenuDetailPageState extends State<ScanMenuDetailPage> {
  TextEditingController searchController = TextEditingController();
  List<StockItem> fullList = [];
  List<StockItem> filteredList = [];
  late Future<List<StockItem>> futureList;

  @override
  void initState() {
    super.initState();
    if (widget.mode == 'in') {
      futureList = HttpService().fetchWhInList();
    } else if (widget.mode == 'out') {
      futureList = HttpService().fetchWhOutList();
    } else if (widget.mode == 'transfer') {
      futureList = HttpService().fetchWhTrnList();
    }

    futureList.then((data) {
      setState(() {
        fullList = data;
        filteredList = data;
      });
    });
  }

  void _filter(String query) {
    setState(() {
      filteredList = fullList.where((item) {
        final codeMatch = item.code.toLowerCase().contains(query.toLowerCase());
        final docCode = widget.mode == 'in' ? item.po : item.so;
        final docMatch = docCode != null &&
            docCode.toLowerCase().contains(query.toLowerCase());

        return codeMatch || docMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My App")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search by code or docCode...",
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: _filter,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<StockItem>>(
              future: futureList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildQrCard(),
                    const SizedBox(height: 16),
                    ...filteredList
                        .map((item) => _buildCard(context, item))
                        .toList(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Scan a barcode to search',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan Now'),
              onPressed: () async {
                final result = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MobileScannerSimple(
                      docCode: '',
                      mode: widget.mode,
                    ),
                  ),
                );

                if (result != null) {
                  searchController.text = result;
                  _filter(result);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, StockItem item) {
    final String? docCode = widget.mode == 'transfer' ? item.code : (widget.mode == 'in' ? item.po : item.so);
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        // leading: const Icon(Icons.image),
        title: Text(item.code),
        subtitle: Text(docCode ?? ''),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(docCode: docCode, mode: widget.mode),
            ),
          );
        },
      ),
    );
  }
}



// class ScanMenuDetailPage extends StatelessWidget {
//   final String mode;
//   const ScanMenuDetailPage({super.key, required this.mode});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("My App")),
//       body: FutureBuilder<List<StockItem>>(
//         future: mode == 'in'
//             ? HttpService().fetchWhInList()
//             : HttpService().fetchWhOutList(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           final stockList = snapshot.data ?? [];

//           return ListView(
//             padding: const EdgeInsets.all(16),
//             children: [
//               _buildQrCard(),
//               const SizedBox(height: 16),
//               ...stockList.map((item) => _buildCard(context, item)).toList(),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildQrCard() {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.network(
//                 'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=https://example.com',
//                 height: 150,
//                 width: 150,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               'Scan the QR code to visit stock',
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCard(BuildContext context, StockItem item) {
//     final String? docCode = mode == 'in' ? item.po : item.so;
//     return Card(
//       elevation: 3,
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         leading: const Icon(Icons.image),
//         title: Text(item.code),
//         subtitle: Text(docCode ?? ''),
//         trailing: const Icon(Icons.arrow_forward_ios),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => HomePage(docCode: docCode, mode: mode),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:flutter_application_7/services/http_service.dart'; // ✅ เพิ่ม import
// import 'package:flutter_application_7/models/stockitem.dart';

// // import 'package:flutter_application_7/data.dart'; // 👉 นำเข้า mock data
// import 'home_page.dart';

// class ScanMenuDetailPage extends StatelessWidget {
//   final String mode;
//   const ScanMenuDetailPage({super.key, required this.mode});

//   String get apiUrl {
//     return mode == 'in'
//         ? 'http://192.168.1.119:8069/get_list_whin'
//         : 'http://192.168.1.119:8069/get_list_whout';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("My App")),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // QR Code
//           Card(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             elevation: 4,
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.network(
//                       'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=https://example.com',
//                       height: 150,
//                       width: 150,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   const Text(
//                     'Scan the QR code to visit stock',
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),

//           const SizedBox(height: 16),
//           ...stockList.map((item) => _buildCard(context, item)).toList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildCard(BuildContext context, Map<String, String> item) {
//     final String? docCode = mode == 'in' ? item['po'] : item['so'];
//     return Card(
//       elevation: 3,
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//           leading: const Icon(Icons.image),
//           title: Text(item['code'] ?? ''),
//           subtitle: Text(docCode ?? ''),
//           trailing: const Icon(Icons.arrow_forward_ios),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) =>
//                     HomePage(docCode: docCode), // ส่งไปหน้าแสดงสินค้า
//               ),
//             );
//           }),
//     );
//   }
// }
