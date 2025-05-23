import 'package:flutter/material.dart';
import 'package:flutter_application_7/widgets/product_card.dart';

Future fetchAll() async {
  // implement fetch data
  await Future.delayed(const Duration(seconds: 2));
  return [
    {
      "id": 1,
      "title": "Product 1",
      "description": "Description of Product 1",
      "price": 100,
      "star": 4.5,
      "imageUrl":
          "https://cdn.grange.co.uk/assets/new-cars/lamborghini/revuelto/revuelto-1_20241107093150469.png"
    },
    {
      "id": 2,
      "title": "Product 2",
      "description": "Description of Product 2",
      "price": 200,
      "star": 4.0,
      "imageUrl":
          "https://cdn.grange.co.uk/assets/new-cars/lamborghini/revuelto/revuelto-1_20241107093150469.png"
    },
    {
      "id": 3,
      "title": "Product 3",
      "description": "Description of Product 3",
      "price": 300,
      "star": 5.0,
      "imageUrl":
          "https://cdn.grange.co.uk/assets/new-cars/lamborghini/revuelto/revuelto-1_20241107093150469.png"
    },
  ];
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
