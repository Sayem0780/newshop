import 'package:flutter/material.dart';
import 'package:newshop/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/order.dart' show Order;
import '../widgets/custombadge.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';
import 'cart_screen.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = 'OrderScreen';
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  late Future _orderFuture;
  Future _obtainOrderFuture() {
    return Provider.of<Order>(context, listen: false).fectAndSetOrder();
  }

  @override
  void initState() {
    _orderFuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Order'),
      ),
      body: FutureBuilder(
        future: _orderFuture,
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapShot.error != null) {
              return const Center(
                child: Text('Something is worng'),
              );
            } else {
              return Consumer<Order>(
                builder: (ctx, orderData, child) {
                  return orderData.order.length==0?Center(
                    child: Container(
                        height: 400,
                        padding: EdgeInsets.all(20),
                        child: Image.asset('assets/images/waiting.png',fit: BoxFit.cover,)),
                  ):ListView.builder(
                    itemBuilder: (ctx, index) {
                      return OrderItem(orderData.order[index]);
                    },
                    itemCount: orderData.order.length,
                  );
                },
              );
            }
          }
        },
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white, // Set your desired background color
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: IconButton(icon: Icon(Icons.home),onPressed: (){
                Navigator.of(context).pushNamed(ProductOverviewScreen.routeName);
              },),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.dashboard_outlined,color: Colors.blueGrey,),
                onPressed: () {
                  Navigator.of(context).pushNamed( OrderScreen.routeName);
                },
              ),
              label: 'Orders',
            ),

            BottomNavigationBarItem(
              icon: Consumer<Cart>(
                builder: (_, cart, ch) => CustomBadge(
                  child: ch,
                  value: cart.itemCounter.toString(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ),
              ),
              label: 'Cart',
            )
            // Add more items as needed
          ],
          // Other properties...
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}