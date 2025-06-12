import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// PO
void showAddLotPoDialog(BuildContext context, String po) {
  final barcodeController = TextEditingController();
  final lotNoController = TextEditingController();
  final qtyController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text("Add Lot (PO)"),
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
          child: const Text('Add'),
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
                Uri.parse('http://172.20.10.4:8069/stock_receive_lot'),
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

void showAddBarPoDialog(BuildContext context, String po) {
  final barcodeController = TextEditingController();
  final qtyController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text("Add Barcode (PO)"),
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
          child: const Text('Add'),
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
                Uri.parse('http://172.20.10.4:8069/stock_receive_barcode'),
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

void showAddSnPoDialog(BuildContext context, String po, String barcode) {
  final barcodeController = TextEditingController();
  final qtyController = TextEditingController();
  List<TextEditingController> snControllers = [TextEditingController()];

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text("Add S/N (PO)"),
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
              child: const Text('Add'),
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
                    Uri.parse('http://172.20.10.4:8069/stock_receive_sn'),
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
