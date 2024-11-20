import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cart_item_model.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class CartListView extends StatelessWidget {
  final List<CartItemModel> items;

  const CartListView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final cartItem = items[index];
        return Card(
          child: ListTile(
            leading: CachedNetworkImage(
              width: 50,
              imageUrl: cartItem.product!.images?[0] ?? '',
            ),
            title: Text(cartItem.product!.brand ?? "Unknown"),
            subtitle: Text("Quantity: ${cartItem.quantity}"),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                // Pass the product ID (cartItem.sId) instead of the entire cartItem
                Provider.of<CartProvider>(context, listen: false)
                    .removeFromCart(cartItem.sId!, 'userId'); // Replace 'userId' with actual user ID
              },
            ),
          ),
        );
      },
    );
  }
}
