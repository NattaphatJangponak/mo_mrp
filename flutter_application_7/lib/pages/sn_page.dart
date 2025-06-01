import 'package:flutter/material.dart';
import 'package:flutter_application_7/data.dart';
import 'package:flutter_application_7/widgets/header_section.dart';

Future fetchData() async {
  // implement fetch data
  await Future.delayed(const Duration(seconds: 2));
  return snPageData;
}

class SnPage extends StatefulWidget {
  const SnPage({super.key});

  @override
  State<SnPage> createState() => _SnPageState();
}

class _SnPageState extends State<SnPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'S/N',
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
            const HeaderSection(title: 'S/N', subtitle: 'SERIAL NUMBER'),
            FutureBuilder(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final List<MockSerialNumber> data = snapshot.data;

                    return Column(
                      children: [
                        DataTable(
                            columns: const [
                              DataColumn(label: Expanded(child: Text("S/N"))),
                              DataColumn(
                                  label: Expanded(child: Text("Action"))),
                            ],
                            rows: data.map((item) {
                              return DataRow(cells: [
                                DataCell(Text(item.serialNumber)),
                                DataCell(
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          _buildDeleteDialog(context, item);
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
                                        '${data.length}',
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

void _buildDeleteDialog(BuildContext context, MockSerialNumber item) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Serial Number'),
        content: Text('Are you sure you want to delete ${item.serialNumber}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement delete
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
