import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/auth_screen.dart';
import '../screens/products_overview_screen.dart';
import '../screens/order_screen.dart';
import '../screens/user_product_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello Friend'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ProductOverviewScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrderScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Product'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProductScreen.routeName),
          ),
          const Divider(),
          Row(
            children: [
              Consumer<Auth>(
                builder: (ctx, acc, child) => IconButton(
                  icon: Icon(Icons.logout_outlined),
                  onPressed: () {
                    acc.logOut();
                    acc.isAuth?null:Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
                  },
                ),
              ),
              Text(
                'Log Out',
                style: TextStyle(color: Theme.of(context).errorColor, fontSize: 18),
              ),

            ],
          ),
        ],
      ),
    );
  }
}