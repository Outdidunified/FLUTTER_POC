import 'package:app/logic/cubit/category/category_cubit.dart';
import 'package:app/logic/cubit/category/category_state.dart';
import 'package:app/presentation/screens/products/category_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoadingState && state.categories.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CategoryErrorState && state.categories.isEmpty) {
            return Center(
              child: Text(state.message.toString()),
            );
          }

          return Column(
            children: [
              // Heading with blue-grey background
              Container(
                width: double.infinity,
                color: Colors.white, // Set background color for the heading
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                  'Categories List',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22, // Increased font size for the heading
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              // List of categories
              Expanded(
                child: ListView.builder(
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];

                    // Asset image path
                    String assetImagePath = 'assets/evlog.jpg';

                    return ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          CategoryProductScreen.routeName,
                          arguments: category,
                        );
                      },
                      leading: Container(
                        width: 130, // Increased width for the image
                        height: 200, // Increased height for the image,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9.0), // Rounded corners for the image
                          child: Image.asset(
                            assetImagePath,
                            width: 300, // Image width
                            height: 300, // Image height
                            fit: BoxFit.cover, // Image fit type
                          ),
                        ),
                      ),
                      title: Text(
                        category.title ?? "No title", // Safely access category title
                        style: const TextStyle(
                          fontSize: 20, // Increased font size for category title
                          fontWeight: FontWeight.normal,
                          color: Colors.lightBlueAccent
                          // Optional: Make title bold
                        ),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
