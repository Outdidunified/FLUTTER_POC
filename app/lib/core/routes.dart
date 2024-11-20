import 'package:app/data/models/product/product_model.dart';
import 'package:app/presentation/screens/auth/providers/login_provider.dart';
import 'package:app/Presentation/screens/products/product_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/presentation/screens/auth/login_screen.dart';
import 'package:app/presentation/screens/auth/signup_screen.dart';
import 'package:app/presentation/screens/home/home_screen.dart';  // Import HomeScreen
import 'package:app/presentation/screens/splash/splash_screen.dart'; // Import SplashScreen
import 'package:provider/provider.dart';
import 'package:app/presentation/screens/auth/providers/signup_provider.dart';
import 'package:app/presentation/screens/cart/cart_screen.dart';
import 'package:app/Presentation/screens/user/edit_profile_screen.dart';
import 'package:app/Presentation/screens/order/order_detail_screen.dart';
import 'package:app/Presentation/screens/order/my_order_screen.dart';
import 'package:app/Presentation/screens/order/order_placed_screen.dart';
import 'package:app/Presentation/screens/order/provider/order_detail_provider.dart';
class Routes {

  static Route? onGenerateRoute(RouteSettings settings) {
    switch(settings.name) {

      case LoginScreen.routeName: return CupertinoPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (context) => LoginProvider(context),
              child: const LoginScreen()
          )
      );

      case SignupScreen.routeName: return CupertinoPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (context) => SignupProvider(context),
              child: const SignupScreen()
          )
      );

      case HomeScreen.routeName: return CupertinoPageRoute(
          builder: (context) => const HomeScreen()
      );

      case SplashScreen.routeName: return CupertinoPageRoute(
          builder: (context) => const SplashScreen()
      );

      case ProductDetailsScreen.routeName: return CupertinoPageRoute(
          builder: (context) => ProductDetailsScreen(
            productModel: settings.arguments as ProductModel,
          )
      );

      case CartScreen.routeName: return CupertinoPageRoute(
          builder: (context) => const CartScreen()
      );



      case EditProfileScreen.routeName: return CupertinoPageRoute(
          builder: (context) => const EditProfileScreen()
      );

      case OrderDetailScreen.routeName: return CupertinoPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (context) => OrderDetailProvider(),
              child: const OrderDetailScreen()
          )
      );

      case OrderPlacedScreen.routeName: return CupertinoPageRoute(
          builder: (context) => const OrderPlacedScreen()
      );

      case MyOrderScreen.routeName: return CupertinoPageRoute(
          builder: (context) => const MyOrderScreen()
      );

      default: return null;

    }
  }

}