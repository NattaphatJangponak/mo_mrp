import 'package:flutter/material.dart';
import 'package:flutter_application_7/pages/lot_page.dart';
import 'package:flutter_application_7/pages/scanner_page.dart';
import 'package:flutter_application_7/pages/sn_page.dart';

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
                      showAddLotPoDialog(context, data['docCode']);
                    } else if (mode == 'out') {
                      // showAddLotSoDialog(context, data['docCode']);
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add Lot'),
                ),
                FilledButton(
                  onPressed: () => showAddBarDialog(context, data['docCode']),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add Bar'),
                ),
                FilledButton(
                  onPressed: () =>
                      showAddSnDialog(context, data['docCode'], data['name']),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('S/N'),
                ),
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

void showAddLotPoDialog(BuildContext context, String po) {
  final barcodeController = TextEditingController();
  final lotNoController = TextEditingController();
  final qtyController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text("Add Lot"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Readonly Po field
            TextFormField(
              initialValue: po,
              enabled: false,
              decoration: const InputDecoration(labelText: 'Po'),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: barcodeController,
              decoration: const InputDecoration(labelText: 'Barcode'),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: lotNoController,
              decoration: const InputDecoration(labelText: 'Lot No'),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: qtyController,
              decoration: const InputDecoration(labelText: 'Receivet QTY'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(backgroundColor: Colors.grey[300]),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlueAccent,
            foregroundColor: Colors.white,
          ),
          child: const Text('Update'),
          onPressed: () async {
            final payload = {
              "jasonrpc": 2.0,
              "params": {
                "po": po,
                "barcode": barcodeController.text.trim(),
                "lot_no": lotNoController.text.trim(),
                "received_qty": int.tryParse(qtyController.text.trim()) ?? 0,
              }
            };

            // ✅ แสดง JSON ที่จะส่งใน SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("📦 Sending JSON:\n${jsonEncode(payload)}"),
                duration: const Duration(seconds: 3),
              ),
            );

            try {
              final response = await http.post(
                Uri.parse('http://192.168.154.40:8069/stock_receive_lot'),
                headers: {"Content-Type": "application/json"},
                body: jsonEncode(payload),
              );

              if (response.statusCode == 200) {
                Navigator.pop(context); // ปิด Dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Updated successfully")),
                );
              } else {
                throw Exception("Failed to update");
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("❌ Error: $e")),
              );
            }
          },
        ),
      ],
    ),
  );
}

void showAddBarDialog(BuildContext context, String po) {
  final barcodeController = TextEditingController();
  final qtyController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text("Add Barcode"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Readonly Po field
            TextFormField(
              initialValue: po,
              enabled: false,
              decoration: const InputDecoration(labelText: 'Po'),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: barcodeController,
              decoration: const InputDecoration(labelText: 'Barcode'),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: qtyController,
              decoration: const InputDecoration(labelText: 'Receivet QTY'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(backgroundColor: Colors.grey[300]),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlueAccent,
            foregroundColor: Colors.white,
          ),
          child: const Text('Update'),
          onPressed: () async {
            final payload = {
              "jasonrpc": 2.0,
              "params": {
                "po": po,
                "barcode": barcodeController.text.trim(),
                "received_qty": int.tryParse(qtyController.text.trim()) ?? 0,
              }
            };

            // ✅ แสดง JSON ที่จะส่งใน SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("📦 Sending JSON:\n${jsonEncode(payload)}"),
                duration: const Duration(seconds: 3),
              ),
            );

            try {
              final response = await http.post(
                Uri.parse('http://192.168.154.40:8069/stock_receive_barcode'),
                headers: {"Content-Type": "application/json"},
                body: jsonEncode(payload),
              );

              if (response.statusCode == 200) {
                Navigator.pop(context); // ปิด Dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Updated successfully")),
                );
              } else {
                throw Exception("Failed to update");
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("❌ Error: $e")),
              );
            }
          },
        ),
      ],
    ),
  );
}

void showAddSnDialog(BuildContext context, String po, String barcode) {
  final barcodeController = TextEditingController();
  final qtyController = TextEditingController();
  List<TextEditingController> snControllers = [TextEditingController()];

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text("Add S/N"),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Readonly fields
                  TextFormField(
                    initialValue: po,
                    enabled: false,
                    decoration: const InputDecoration(labelText: 'Po'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: barcodeController,
                    decoration: const InputDecoration(labelText: 'Barcode'),
                  ),
                  const SizedBox(height: 12),

                  const SizedBox(height: 12),

                  // Qty field
                  TextFormField(
                    controller: qtyController,
                    decoration:
                        const InputDecoration(labelText: 'Receivet QTY'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Reorderable SN inputs
                  const Text('Serial Numbers'),
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snControllers.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex -= 1;
                        final item = snControllers.removeAt(oldIndex);
                        snControllers.insert(newIndex, item);
                      });
                    },
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: ValueKey(snControllers[index]),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          setState(() {
                            snControllers.removeAt(index);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: TextFormField(
                            controller: snControllers[index],
                            decoration: InputDecoration(
                              labelText: 'SN ${index + 1}',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        snControllers.add(TextEditingController());
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add SN"),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style:
                  TextButton.styleFrom(backgroundColor: Colors.grey.shade300),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Update'),
              onPressed: () async {
                final snList = snControllers
                    .map((e) => e.text.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();

                final payload = {
                  "jsonrpc": "2.0",
                  "method": "call",
                  "params": {
                    "po": po,
                    "barcode": barcodeController.text.trim(),
                    "sn_no": snList,
                    "received_qty":
                        int.tryParse(qtyController.text.trim()) ?? 0,
                  }
                };

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("📦 Sending JSON:\n${jsonEncode(payload)}"),
                    duration: const Duration(seconds: 3),
                  ),
                );

                try {
                  final response = await http.post(
                    Uri.parse('http://192.168.154.40:8069/stock_receive_sn'),
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode(payload),
                  );

                  if (response.statusCode == 200) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("✅ SN Update successful")),
                    );
                  } else {
                    throw Exception(
                        "Failed with status ${response.statusCode}");
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("❌ Error: $e")),
                  );
                }
              },
            ),
          ],
        );
      });
    },
  );
}

// void showAddLotSoDialog(BuildContext context, String so, String barcode) {
//   final barcodeController = TextEditingController();
//   final qtyController = TextEditingController();
//   List<TextEditingController> snControllers = [TextEditingController()];

//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       return StatefulBuilder(builder: (context, setState) {
//         return AlertDialog(
//           title: const Text("Add S/N"),
//           content: SizedBox(
//             width: double.maxFinite,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Readonly fields
//                   TextFormField(
//                     initialValue: po,
//                     enabled: false,
//                     decoration: const InputDecoration(labelText: 'Po'),
//                   ),
//                   const SizedBox(height: 12),
//                   TextFormField(
//                     controller: barcodeController,
//                     decoration: const InputDecoration(labelText: 'Barcode'),
//                   ),
//                   const SizedBox(height: 12),

//                   const SizedBox(height: 12),

//                   // Qty field
//                   TextFormField(
//                     controller: qtyController,
//                     decoration:
//                         const InputDecoration(labelText: 'Receivet QTY'),
//                     keyboardType: TextInputType.number,
//                   ),
//                   const SizedBox(height: 16),

//                   // Reorderable SN inputs
//                   const Text('Serial Numbers'),
//                   ReorderableListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: snControllers.length,
//                     onReorder: (oldIndex, newIndex) {
//                       setState(() {
//                         if (newIndex > oldIndex) newIndex -= 1;
//                         final item = snControllers.removeAt(oldIndex);
//                         snControllers.insert(newIndex, item);
//                       });
//                     },
//                     itemBuilder: (context, index) {
//                       return Dismissible(
//                         key: ValueKey(snControllers[index]),
//                         direction: DismissDirection.endToStart,
//                         background: Container(
//                           color: Colors.red,
//                           alignment: Alignment.centerRight,
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           child: const Icon(Icons.delete, color: Colors.white),
//                         ),
//                         onDismissed: (_) {
//                           setState(() {
//                             snControllers.removeAt(index);
//                           });
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 6),
//                           child: TextFormField(
//                             controller: snControllers[index],
//                             decoration: InputDecoration(
//                               labelText: 'SN ${index + 1}',
//                               border: const OutlineInputBorder(),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),

//                   const SizedBox(height: 8),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       setState(() {
//                         snControllers.add(TextEditingController());
//                       });
//                     },
//                     icon: const Icon(Icons.add),
//                     label: const Text("Add SN"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               style:
//                   TextButton.styleFrom(backgroundColor: Colors.grey.shade300),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.lightBlueAccent,
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text('Update'),
//               onPressed: () async {
//                 final snList = snControllers
//                     .map((e) => e.text.trim())
//                     .where((e) => e.isNotEmpty)
//                     .toList();

//                 final payload = {
//                   "jsonrpc": "2.0",
//                   "method": "call",
//                   "params": {
//                     "po": po,
//                     "barcode": barcodeController.text.trim(),
//                     "sn_no": snList,
//                     "received_qty":
//                         int.tryParse(qtyController.text.trim()) ?? 0,
//                   }
//                 };

//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text("📦 Sending JSON:\n${jsonEncode(payload)}"),
//                     duration: const Duration(seconds: 3),
//                   ),
//                 );

//                 try {
//                   final response = await http.post(
//                     Uri.parse('http://192.168.154.40:8069/stock_receive_sn'),
//                     headers: {"Content-Type": "application/json"},
//                     body: jsonEncode(payload),
//                   );

//                   if (response.statusCode == 200) {
//                     Navigator.pop(context);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("✅ SN Update successful")),
//                     );
//                   } else {
//                     throw Exception(
//                         "Failed with status ${response.statusCode}");
//                   }
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("❌ Error: $e")),
//                   );
//                 }
//               },
//             ),
//           ],
//         );
//       });
//     },
//   );
// }

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
