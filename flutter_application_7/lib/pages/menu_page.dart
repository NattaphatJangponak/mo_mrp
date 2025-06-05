import 'package:flutter/material.dart';
import 'home_page.dart'; // หน้า HomePage
import 'scan_menu_detail.dart';
import 'selecttransfer_page.dart';
import 'countingstock_page.dart';
import '../main.dart'; // หน้า AboutPage (อยู่ใน main)

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menu")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildMenuTile(
            context,
            title: 'Receive',
            icon: Icons.download,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const ScanMenuDetailPage(mode: 'in'), // หรือ 'out'
                ),
              );
            },
          ),
          _buildMenuTile(
            context,
            title: 'Delivery',
            icon: Icons.local_shipping,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ScanMenuDetailPage(mode: 'out'),
                ),
              );
            },
          ),
          _buildMenuTile(
            context,
            title: 'Internal transfer',
            icon: Icons.compare_arrows,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SelectTransferPage(),
                ),
              );
            },
          ),
          _buildMenuTile(
            context,
            title: 'Counting Stock',
            icon: Icons.checklist,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CountingStockPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
