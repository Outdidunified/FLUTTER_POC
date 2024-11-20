import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cart_provider.dart';
import 'package:provider/provider.dart';
import 'primary_button.dart';
import 'formatter.dart';
import 'cart_item_model.dart';
import 'product_model.dart';

class ProductScreen extends StatelessWidget {
  final ProductModel productModel;  // Define the productModel parameter

  const ProductScreen({Key? key, required this.productModel}) : super(key: key);  // Update constructor

  static const routeName = "product_details";

  @override
  Widget build(BuildContext context) {
    // Now productModel is available here
    return Scaffold(
      appBar: AppBar(
        title: Text(productModel.brand ?? "Product Details"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            CachedNetworkImage(
              imageUrl: productModel.images?.first ?? '',
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productModel.brand ?? "Unknown Brand",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    Formatter.formatPrice(productModel.price ?? 0),
                    style: TextStyle(fontSize: 20, color: Colors.green),
                  ),
                  SizedBox(height: 16),
                  Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      final isInCart = cart.cartItems.any((item) =>
                      item.product?.sId != null && productModel.sId != null && item.product!.sId == productModel.sId
                      );


                      return PrimaryButton(
                        onPressed: () {
                          if (!isInCart) {
                            cart.addToCart(CartItemModel(product: productModel, quantity: 1), 'userId');
                          }
                        },
                        text: isInCart ? "Added to Cart" : "Add to Cart",
                        color: isInCart ? Colors.grey : Colors.blue,
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(productModel.description ?? "No description available."),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
