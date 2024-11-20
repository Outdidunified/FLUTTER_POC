import 'package:flutter/material.dart';
import '/cart_provider.dart';
import 'cart_list_view.dart';
import 'package:provider/provider.dart';
import 'calculations.dart';
import 'formatter.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const routeName = "cart";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        child: Consumer<CartProvider>(
          builder: (context, cart, child) {
            if (cart.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (cart.cartItems.isEmpty) {
              return const Center(child: Text("Your cart is empty."));
            }

            return Column(
              children: [
                Expanded(child: CartListView(items: cart.cartItems)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${cart.cartItems.length} items"),
                          Text("Total: ${Formatter.formatPrice(Calculations.cartTotal(cart.cartItems))}"),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle checkout
                        },
                        child: const Text("Proceed to Checkout"),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
