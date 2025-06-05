import 'package:flutter/material.dart';
import 'package:flutter_application_7/data.dart'; // 👉 นำเข้า mock data
import 'home_page.dart';

class ScanMenuDetailPage extends StatelessWidget {
  final String mode;
  const ScanMenuDetailPage({super.key, required this.mode});


  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> stockList =
        mode == 'in' ? mockStockList : mockStockList2;
    return Scaffold(
      appBar: AppBar(title: const Text("My App")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // QR Code
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=https://example.com',
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Scan the QR code to visit stock',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const SizedBox(height: 16),
          ...stockList.map((item) => _buildCard(context, item)).toList(),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, String> item) {
    final String? docCode = mode == 'in' ? item['po'] : item['so'];
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
          leading: const Icon(Icons.image),
          title: Text(item['code'] ?? ''),
          subtitle: Text(docCode ?? ''),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    HomePage(docCode: docCode), // ส่งไปหน้าแสดงสินค้า
              ),
            );
          }),
    );
  }
}
