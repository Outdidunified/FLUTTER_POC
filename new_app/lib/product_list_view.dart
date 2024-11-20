import 'package:flutter/material.dart';
import 'product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'product_screen.dart';
import 'formatter.dart';

class ProductListView extends StatelessWidget {
  final List<ProductModel> products;

  const ProductListView({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ProductScreen.routeName, arguments: product);
          },
          child: Row(
            children: [
              CachedNetworkImage(
                width: MediaQuery.of(context).size.width / 3,
                imageUrl: product.images?.first ?? '',
                fit: BoxFit.cover,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brand ?? "Unknown Brand",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      product.description ?? "No description available.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(Formatter.formatPrice(product.price ?? 0)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
