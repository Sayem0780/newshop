import 'package:flutter/material.dart';
import 'package:newshop/providers/product.dart';
import 'package:newshop/screens/detail_page.dart';
import 'package:provider/provider.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/order.dart';
import './screens/order_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return MultiProvider(
            providers: [
                ChangeNotifierProvider(create: (context) => Auth()),
                ChangeNotifierProxyProvider<Auth, Products>(
                    update: (ctx, auth, products) =>
                        Products(auth.token, products!.item, auth.userId),
                    create: (context) => Products('', [], ''),
                ),
                ChangeNotifierProvider(
                    create: (context) => Cart(),
                ),

                ChangeNotifierProxyProvider<Auth, Order>(
                    update: (ctx, auth, order) =>
                        Order(auth.token, order!.order, auth.userId),
                    create: (context) => Order(
                        '',
                        [],
                        '',
                    ),
                ),
            ],
            child: Consumer<Auth>(
                builder: (ctx, auth, child) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'My Shop',
                    theme: ThemeData(
                        fontFamily: 'Lato',
                        colorScheme: ColorScheme.fromSwatch(
                            primarySwatch: Colors.blueGrey).
                        copyWith(
                            secondary: Colors.deepOrange)
                    ),
                    home: auth.isAuth
                        ? ProductOverviewScreen()
                        : FutureBuilder(
                        future: auth.autoLogIn(),
                        builder: (ctx, dataSnapShot) =>
                        dataSnapShot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
                    routes: {
                        ProductOverviewScreen.routeName: (ctx) =>
                        const ProductOverviewScreen(),
                        DetailPage.routeName:(ctx) => const DetailPage(),
                        CartScreen.routeName: (ctx) => const CartScreen(),
                        OrderScreen.routeName: (ctx) => const OrderScreen(),
                        UserProductScreen.routeName: (ctx) => const UserProductScreen(),
                        EditProductScreen.routeName: (ctx) => const EditProductScreen(),
                        AuthScreen.routeName:(ctx)=>  AuthScreen(),
                    },
                ),
            ),
        );
    }
}