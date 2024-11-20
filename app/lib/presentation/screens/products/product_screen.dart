import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/data/models/product/product_model.dart';
import 'package:app/logic/cubit/cart/cart_cubit.dart';
import 'package:app/logic/services/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/Presentation/widgets/gap_widgets.dart';
import 'package:app/Presentation/widgets/primary_button.dart';
import 'package:app/logic/cubit/cart/cart_state.dart';
import 'package:app/core/ui.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel productModel;
  const ProductDetailsScreen({Key? key, required this.productModel}) : super(key: key);

  static const routeName = "product_details";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productModel.brand ?? "Product Details"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            // Image Slider using CarouselSlider
            CarouselSlider(
              items: productModel.images?.map((imageUrl) {
                return CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                );
              }).toList() ?? [],
              options: CarouselOptions(
                height: 300,
                viewportFraction: 1.0,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
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
                  BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      final isInCart = context.read<CartCubit>().cartContains(productModel);

                      return PrimaryButton(
                        onPressed: () {
                          if (!isInCart) {
                            context.read<CartCubit>().addToCart(productModel, 1);
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
