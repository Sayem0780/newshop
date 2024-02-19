import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:newshop/screens/order_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widgets/banner.dart';
import '../widgets/category_item.dart';
import '../widgets/item.dart';
import '../widgets/products_grid.dart';
import '../widgets/custombadge.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import 'auth_screen.dart';

enum FilterOptions { MyFavourite, All }

class ProductOverviewScreen extends StatefulWidget {
    static const routeName = 'ProductOverviewScreen';
    const ProductOverviewScreen({Key? key}) : super(key: key);

    @override
    State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
    var _showFavouriteProduct = false;
    var _isInit = true;
    var _isLoading = false;

    @override
    void didChangeDependencies() {
        if (_isInit) {
            setState(() {
                _isLoading = true;
            });
            Provider.of<Products>(context).fectAndSetProduct().then((_) {
                setState(() {
                    _isLoading = false;
                });
            });
        }
        _isInit = false;
        super.didChangeDependencies();
    }

    int selectedCategory = 0;
    List<String> list = ['T-Shirt', 'Shirts', 'Blazers', 'Jacket'];

    @override
    Widget build(BuildContext context) {
        final argsFav = ModalRoute.of(context)!.settings.arguments as dynamic;
        argsFav!=null?_showFavouriteProduct=true:_showFavouriteProduct=_showFavouriteProduct;
        Size size = MediaQuery.of(context).size;
        return Scaffold(
            appBar: AppBar(
                title: _showFavouriteProduct
                    ? const Text('Your Favourites')
                    : const Text('My Shop'),
                actions: [
                    Consumer<Auth>(
                        builder: (ctx, acc, child) => IconButton(
                            icon: Icon(Icons.logout_outlined),
                            onPressed: () {
                               acc.logOut();
                               acc.isAuth?null:Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
                            },
                        ),
                    ),
                ],
            ),
            body: _isLoading
                ? const Center(
                child: CircularProgressIndicator(),
            )
                :Stack(
                children: [
                    Container(
                        height: 240,
                        width: size.width,
                        decoration: const BoxDecoration(color: Color(0xff131313)),
                    ),
                    Column(
                        children: [
                            Center(
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width*.9,
                                    child: Column(
                                        children: [
                                            SizedBox(
                                                height: size.height * 0.060,
                                            ),
                                            SizedBox(
                                                height: 52,
                                                child: TextFormField(
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        fillColor: const Color(0xff313131),
                                                        contentPadding: const EdgeInsets.only(
                                                            top: 23,
                                                            bottom: 2,
                                                            right: 5,
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(16),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(16),
                                                        ),
                                                        hintText: "Search",
                                                        hintStyle: GoogleFonts.sora(
                                                            color: const Color(0xff989898),
                                                        ),
                                                        prefixIcon: const Icon(
                                                            Iconsax.search_normal,
                                                            color: Colors.white,
                                                            size: 20,
                                                        ),
                                                        suffixIcon: Container(
                                                            width: 44,
                                                            height: 44,
                                                            padding: const EdgeInsets.all(8),
                                                            decoration: BoxDecoration(
                                                                color: const Color(0xffC67C4E),
                                                                borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            child: const Icon(
                                                                Iconsax.setting_4,
                                                                color: Colors.white,
                                                                size: 20,
                                                            ),
                                                        ),
                                                    ),
                                                ),
                                            ),
                                            SizedBox(
                                                height: size.height * 0.020,
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context).size.width*.87,
                                                height: MediaQuery.of(context).size.height*.27,
                                                child: CarouselSlider(
                                                    options: CarouselOptions(
                                                        viewportFraction: 1,
                                                        enlargeFactor: 0.3,
                                                        height: size.height * 0.22,
                                                        enlargeCenterPage: true,
                                                        autoPlay: true,
                                                    ),
                                                    items: List.generate(
                                                        5,
                                                            (index) => const BannerCard(),
                                                    ),
                                                ),
                                            ),
                                            SizedBox(
                                                height: 40,
                                                child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                        children: List.generate(
                                                            list.length,
                                                                (index) => CategoryItem(
                                                                index: index,
                                                                title: list[index],
                                                                selectedCategory: selectedCategory,
                                                                onClick: () {
                                                                    setState((){
                                                                        selectedCategory = index;
                                                                    });
                                                                },
                                                            ),
                                                        ),
                                                    ),
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                            ),
                            SizedBox(
                                height: size.height * 0.020,
                            ),
                            Container(
                                height: 250,
                                width: 400,
                                alignment: Alignment.center,
                                child: ProductsGrid(_showFavouriteProduct),
                            )
                        ],
                    ),
                ],
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
                            icon: IconButton(icon: Icon(Icons.home,color: Colors.blueGrey,),onPressed: (){
                                setState(() {
                                    _showFavouriteProduct = false;
                                });
                            },),
                            label: 'Home',
                        ),
                        BottomNavigationBarItem(
                            icon: IconButton(
                                icon: Icon(Icons.dashboard_outlined),
                                onPressed: () {
                                 Navigator.of(context).pushNamed( OrderScreen.routeName);
                                },
                            ),
                            label: 'Orders',
                        ),
                        BottomNavigationBarItem(
                            icon: IconButton(icon:  _showFavouriteProduct == true?Icon(Icons.favorite,color: Colors.redAccent,):Icon(Icons.favorite),onPressed: (){
                                setState(() {
                                    _showFavouriteProduct = true;
                                });
                                },),
                            label: 'Favorites',
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