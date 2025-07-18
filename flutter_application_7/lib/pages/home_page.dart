import 'package:flutter/material.dart';
import 'package:flutter_application_7/data.dart';
import 'package:flutter_application_7/widgets/product_card.dart';

import 'package:flutter_application_7/services/http_service.dart';

Future fetchAll() async {
  // implement fetch data
  await Future.delayed(const Duration(seconds: 2));
  return products;
}

class HomePage extends StatefulWidget {
  final String? docCode;
  final String mode;
  const HomePage({super.key, this.docCode, required this.mode});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final httpService = HttpService();
  late Future<List<Map<String, dynamic>>> futureData;

  @override
  void initState() {
    super.initState();

    if (widget.mode == 'transfer') {
      futureData = httpService.fetchTrnLines(
          widget.docCode!); // ใช้ fetchTrnLines สำหรับ 'transfer'
    } else if (widget.docCode != null && widget.docCode!.startsWith('P')) {
      futureData = httpService
          .fetchPoLines(widget.docCode!); // ใช้ fetchPoLines สำหรับ 'P'
    } else if (widget.docCode != null && widget.docCode!.startsWith('S')) {
      futureData = httpService
          .fetchSoLines(widget.docCode!); // ใช้ fetchSoLines สำหรับ 'S'
    } else {
      futureData = Future.value(
          []); // ถ้าไม่มี docCode หรือไม่ตรงกับกรณีใดๆ ก็คืนค่าว่าง
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // QR Code Scanner
            if (widget.docCode != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      widget.docCode!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ),
              ),

            // item list
            FutureBuilder<List<Map<String, dynamic>>>(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Something went wrong: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No data available');
                  }

                  final lines = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: lines.length,
                    itemBuilder: (context, index) {
                      final line = lines[index];
                      return ProductCard(
                        id: index,
                        name: line['line_name'] ?? '',
                        description: 'Qty: ${line['qty']}',
                        imageUrl: '',
                        docCode: widget.docCode,
                        mode: widget.mode,
                      );
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
