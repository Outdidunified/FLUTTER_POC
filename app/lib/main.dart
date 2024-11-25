import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/logic/cubit/user/user_cubit.dart';
import 'package:app/logic/cubit/product/product_cubit.dart';
import 'package:app/logic/cubit/cart/cart_cubit.dart';
import 'package:app/logic/cubit/order/order_cubit.dart';
import 'package:app/logic/cubit/theme/theme_cubit.dart'; // Import ThemeCubit
import 'package:app/presentation/screens/splash/splash_screen.dart';
import 'package:app/core/routes.dart';
import 'package:app/logic/cubit/category/category_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => ProductCubit()),
        BlocProvider(create: (context) => CategoryCubit()),
        BlocProvider(create: (context) => CartCubit(BlocProvider.of<UserCubit>(context))),
        BlocProvider(create: (context) => OrderCubit(BlocProvider.of<UserCubit>(context), BlocProvider.of<CartCubit>(context))),
        BlocProvider(create: (context) => ThemeCubit()), // Add ThemeCubit here
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeMode,
            onGenerateRoute: Routes.onGenerateRoute,
            initialRoute: SplashScreen.routeName,
          );
        },
      ),
    );
  }
}
