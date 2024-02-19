import 'package:newshop/screens/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';

class Item extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final double price;
  final String productid;

  const Item(
      {super.key,
      required this.image,
      required this.title,
      required this.description,
      required this.price,
      required this.productid});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(DetailPage.routeName, arguments: widget.productid);
      },
      child: Container(
        height: 539,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 15, left: 13, right: 13, bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 142,
                      height: 123,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(widget.image),
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            scale: 1),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: -1,
                      child: Container(
                        width: 51,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.transparent.withOpacity(0.5),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Iconsax.star1,
                              color: Color(0xffffbbe21),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              "4.9",
                              style: GoogleFonts.sora(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  widget.title,
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff2F2D2C),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  widget.description.substring(0, 10),
                  style: GoogleFonts.sora(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff9B9B9B),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$ ${widget.price.toString()}",
                      style: GoogleFonts.sora(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff2F4B4E),
                      ),
                    ),
                    Consumer<Product>(
                      builder: (ctx, prd, child) => IconButton(
                        icon: Icon(
                          prd.isFavourite!
                              ? Icons.favorite_outlined
                              : Icons.favorite_outline,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {
                          prd.toggleFavourite(auth.token, auth.userId);
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {
                        cart.addItem(
                            widget.productid, widget.title, widget.price),
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Added item to cart!'),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: () {
                                cart.removeSingleItem(widget.productid);
                              },
                            ),
                          ),
                        ),
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xffC67C4E),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
