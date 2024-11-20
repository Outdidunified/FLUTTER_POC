import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/logic/cubit/order/order_cubit.dart';
import 'package:app/logic/cubit/order/order_state.dart';
import 'package:app/logic/services/calculations.dart';
import 'package:app/logic/services/formatter.dart';
import 'package:app/presentation/widgets/gap_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/ui.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  static const routeName = "my_orders";

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
      ),
      body: SafeArea(
        child: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            // Handle loading state
            if (state is OrderLoadingState && state.orders.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Handle error state
            if (state is OrderErrorState && state.orders.isEmpty) {
              return Center(
                child: Text(state.message),
              );
            }

            // Main list of orders
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              separatorBuilder: (context, index) {
                return Column(
                  children: [
                    const GapWidget(),
                    Divider(color: AppColors.textLight),
                    const GapWidget(),
                  ],
                );
              },
              itemBuilder: (context, index) {
                final order = state.orders[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order ID
                    Text(
                      "# - ${order.sId}",
                      style: TextStyles.body2.copyWith(color: AppColors.textLight),
                    ),

                    // Order Date
                    Text(
                      Formatter.formatDate(order.createdOn!),
                      style: TextStyles.body2.copyWith(color: AppColors.accent),
                    ),

                    // Order Total
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Order Total: ${Formatter.formatPrice(Calculations.cartTotal(order.items!))}",
                        style: TextStyles.body1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18, // Increased font size for better visibility
                          color: Colors.white, // Use black or another contrasting color for better visibility
                        ),
                      ),
                    ),

                    // List of items in the order
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: order.items!.length,
                      itemBuilder: (context, index) {
                        final item = order.items![index];
                        final product = item.product!;

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CachedNetworkImage(
                            imageUrl: product.images![0],
                            placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                            width: 80, // Increased image size
                            height: 80, // Increased image size
                            fit: BoxFit.cover, // Ensure proper scaling of image
                          ),
                          title: Text(
                            "${product.brand}",
                            style: TextStyles.body1.copyWith(
                                fontSize: 16, color: Colors.white), // Adjusted font color
                          ),
                          subtitle: Text("Qty: ${item.quantity}"),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Product price
                              Text(
                                Formatter.formatPrice(product.price! * item.quantity!),
                                style: TextStyles.body2.copyWith(fontSize: 14,color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Order status
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Status: ${order.status}",
                        style: TextStyles.body2.copyWith(
                          fontSize: 14,
                          color: Colors.white, // Use a darker color for the status text
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
