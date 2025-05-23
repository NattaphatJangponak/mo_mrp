import 'package:flutter/material.dart';

Future fetchData(String id) async {
  // implement fetch data
  await Future.delayed(const Duration(seconds: 2));
  return {
    "id": id,
    "title": "Product $id",
    "description":
        "lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    "imageUrl":
        "https://cdn.grange.co.uk/assets/new-cars/lamborghini/revuelto/revuelto-1_20241107093150469.png"
  };
}

class DetailPage extends StatefulWidget {
  final int productId;

  const DetailPage({super.key, required this.productId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Page'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: fetchData("${widget.productId}"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final data = snapshot.data;
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(data['title'],
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      Image.network(data['imageUrl']),
                      Text(data['description']),
                    ],
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              }),
        ));
  }
}
