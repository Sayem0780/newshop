import 'package:flutter/material.dart';
import 'package:newshop/widgets/item.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool? showfav;
  const ProductsGrid(this.showfav);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showfav! ? productData.favItem : productData.item;
    print('The length is '+products.length.toString());
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: Item(
            image: productData.item[index].imageUrl.toString(),
            title: productData.item[index].title.toString(),
            description: productData.item[index].description.toString(),
            price: productData.item[index].price!,
            productid: productData.item[index].id.toString(),
          ),
        );
      },
      itemCount: products.length,
    );
  }
}