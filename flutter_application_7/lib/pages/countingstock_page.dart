import 'package:flutter/material.dart';
import 'package:flutter_application_7/data.dart';

class CountingStockPage extends StatefulWidget {
  const CountingStockPage({super.key});

  @override
  State<CountingStockPage> createState() => _CountingStockPageState();
}

class _CountingStockPageState extends State<CountingStockPage> {
  List<CountingItem> items = [];

  @override
  void initState() {
    super.initState();
    items = List.from(countingStockMock); // Clone mock
  }

  int get totalSelectedQty => items
      .where((item) => item.selected)
      .fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My App")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    "Counting Stock",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 24,
                columns: const [
                  DataColumn(label: Text("")),
                  DataColumn(label: Text("Product")),
                  DataColumn(label: Text("Qty")),
                  DataColumn(label: Text("Lot")),
                  DataColumn(label: Text("Location")),
                  DataColumn(label: Text("Action")),
                ],
                rows: items.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Checkbox(
                          value: item.selected,
                          onChanged: (val) {
                            setState(() {
                              item.selected = val ?? false;
                            });
                          },
                        ),
                      ),
                      DataCell(Text(item.product)),
                      DataCell(Text('${item.quantity}')),
                      DataCell(Text(item.lotId)),
                      DataCell(Text(item.locationId)),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _buildDeleteDialog(
                              context,
                              onConfirm: () {
                                setState(() {
                                  items.remove(item);
                                });
                              },
                              title: item.product, // หรือ item.lot แล้วแต่กรณี
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '$totalSelectedQty',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Success'),
                        content: const Text('Update successful!'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _buildDeleteDialog(
  BuildContext context, {
  required VoidCallback onConfirm,
  required String title,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onConfirm(); // เรียก callback เมื่อกดยืนยัน
              Navigator.of(context).pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
