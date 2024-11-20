import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_provider.dart';
import 'user_provider.dart';
import 'cart_provider.dart';  // Import CartProvider
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'product_screen.dart';
import 'product_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()), // Add CartProvider here
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        SignupScreen.routeName: (context) => SignupScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        CartScreen.routeName: (context) => const CartScreen(),
        ProductScreen.routeName: (context) {
          // Extract the 'productModel' from route arguments
          final productModel = ModalRoute.of(context)?.settings.arguments as ProductModel?;

          // Check if productModel is valid, otherwise show a fallback screen or error
          if (productModel == null) {
            return Scaffold(
              appBar: AppBar(title: Text("Error")),
              body: Center(child: Text("No product data available.")),
            );
          }

          // Return the ProductScreen with the valid productModel
          return ProductScreen(productModel: productModel);
        },
      },
    );
  }
}
