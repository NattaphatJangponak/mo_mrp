import 'package:flutter/material.dart';
import 'package:flutter_application_7/data.dart';
import 'package:flutter_application_7/widgets/header_section.dart';

Future fetchData() async {
  // implement fetch data
  await Future.delayed(const Duration(seconds: 1));
  return lotPageData;
}

class LotPage extends StatefulWidget {
  const LotPage({super.key});

  @override
  State<LotPage> createState() => _LotPageState();
}

class _LotPageState extends State<LotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Lot',
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
            const HeaderSection(title: 'Lot', subtitle: 'STOCK'),
            FutureBuilder(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final List<LotMock> data = snapshot.data;
                    int sumQty = data.fold(0, (sum, lot) => sum + lot.qty);
                    return Column(
                      children: [
                        DataTable(
                            columns: const [
                              DataColumn(label: Expanded(child: Text("Lot"))),
                              DataColumn(
                                  label: Expanded(child: Text("Product"))),
                              DataColumn(label: Expanded(child: Text("Qty"))),
                              DataColumn(
                                  label: Expanded(child: Text("Action"))),
                            ],
                            rows: data.map((lot) {
                              return DataRow(cells: [
                                DataCell(Text(lot.lot)),
                                DataCell(Text(lot.product)),
                                DataCell(Text(lot.qty.toString())),
                                DataCell(
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          _buildEditDialog(context, lot);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          _buildDeleteDialog(context, lot);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ]);
                            }).toList()),
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
                                  onPressed: () {},
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
                                    'Send',
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

void _buildEditDialog(BuildContext context, LotMock lot) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Lot'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: lot.lot),
              decoration: const InputDecoration(labelText: 'Lot'),
            ),
            TextField(
              controller: TextEditingController(text: lot.product),
              decoration: const InputDecoration(labelText: 'Product'),
            ),
            TextField(
              controller: TextEditingController(text: lot.qty.toString()),
              decoration: const InputDecoration(labelText: 'Qty'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement save changes
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

void _buildDeleteDialog(BuildContext context, LotMock lot) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Lot'),
        content: Text('Are you sure you want to delete ${lot.lot}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement delete
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red))  ,
          ),
        ],
      );
    },
  );
}
