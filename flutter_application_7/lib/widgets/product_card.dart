import 'package:flutter/material.dart';
import 'package:flutter_application_7/pages/detail_page.dart';

class ProductCard extends StatelessWidget {
  final int id;
  final String name;
  final String description;
  final String imageUrl;

  const ProductCard(
      {super.key,
      required this.id,
      required this.name,
      required this.description,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          leading: Image.network(
            imageUrl,
            width: 100,
            fit: BoxFit.cover,
          ),
          title: Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            debugPrint('Go to detail page');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    productId: id,
                  ),
                ));
          },
        ),
      ),
    );
  }
}
