import 'package:flutter/material.dart';
import 'package:flutter_application_7/data.dart';
import 'package:flutter_application_7/widgets/product_card.dart';

Future fetchAll() async {
  // implement fetch data
  await Future.delayed(const Duration(seconds: 2));
  return products;
}

class HomePage extends StatefulWidget {
  final String? docCode;
  const HomePage({super.key, this.docCode});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            FutureBuilder(
                future: fetchAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Something went wrong: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                    return const Text('No data available');
                  }

                  final products = snapshot.data;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        id: product['id'],
                        name: product['title'],
                        description: product['description'],
                        imageUrl: product['imageUrl'],
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
