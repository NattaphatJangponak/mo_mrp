import 'package:flutter/material.dart';
import 'package:flutter_application_7/data.dart';
import 'package:flutter_application_7/widgets/header_section.dart';

Future fetchData() async {
  // implement fetch data
  await Future.delayed(const Duration(seconds: 2));
  return scannerPageData;
}

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  List<ScannerMock> items = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Scanner',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            const HeaderSection(title: 'Scanner', subtitle: 'BARCODE'),
            FutureBuilder(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final List<ScannerMock> data = snapshot.data;
                    int sumQty =
                        data.fold(0, (sum, item) => sum + item.quantity);
                    return Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 24, // เพิ่ม spacing
                            columns: const [
                              DataColumn(label: Text("Product")),
                              DataColumn(label: Text("Qty")),
                              DataColumn(label: Text("Action")),
                            ],
                            rows: data.map((item) {
                              return DataRow(cells: [
                                DataCell(Text(item.title)),
                                DataCell(Text(item.quantity.toString())),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () =>
                                            _buildEditDialog(context, item),
                                      ),
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
                                            title: item
                                                .title, // หรือ item.lot แล้วแต่กรณี
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                          child: Text(
                                        '$sumQty',
                                        style: const TextStyle(fontSize: 20),
                                      )))),

                              const SizedBox(height: 16),

                              // Send button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Success'),
                                          content:
                                              const Text('Update successful!'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
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
                      ],
                    );
                  } else {
                    return const Text('No data available');
                  }
                }),
          ],
        ),
      ),
    );
  }
}

void _buildEditDialog(BuildContext context, ScannerMock item) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: item.title),
              decoration: const InputDecoration(hintText: 'Enter new title'),
            ),
            TextField(
              controller: TextEditingController(text: item.quantity.toString()),
              decoration: const InputDecoration(hintText: 'Enter new quantity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement save
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
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
