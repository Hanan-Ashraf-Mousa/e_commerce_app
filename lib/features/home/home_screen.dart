import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_app/features/products/products_category_screen.dart';
import 'package:e_commerce_app/models/category_model.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/network/firbase_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../network/api_manager.dart';
import '../auth/login_screen.dart';
import '../products/cart_screen.dart';
import 'my_search_delegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CategoryModel> categories = [];
  List<ProductModel> products = [];
  String name ='';
  @override
  void initState() {
    super.initState();
    getCategoriesList();
    getProducts();
    getCurrentUser();
  }

  getCategoriesList() async {
    categories = await ApiManger.getCategories();
    setState(() {});
  }
  getProducts()async{
    List<ProductModel> productList = await ApiManger.getProducts();
   products= productList;
    setState(() {

    });
  }
  getCurrentUser()async{
    final id = await FirebaseAuth.instance.currentUser!.uid ;
     UserModel? user = await FirebaseManager.getUserProfile(id);
     if(user!=null){
       name = user.name;
     }else{
       name ='Guest';
     }
   setState(() {

   });
  }

  Future<void> navigateToProductsScreen(
    BuildContext context,
    String categoryId,
    String categoryName,
  ) async {
    try {
      final products = await ApiManger.getProductsOnSpecificCategory(
        categoryId,
      );
        Navigator.pushNamed(
          context,
          ProductsCategoryScreen.routeName,
          arguments: {'products': products, 'categoryName': categoryName},
        );

    } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading products: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff004182),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Welcome Back , $name ',
            style: TextStyle(fontSize: 20 , color: Colors.white),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
            },
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: MySearchDelegate(products:products));
            },
            icon: Icon(Icons.search, color: Colors.white54, size: 30),
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            icon: Icon(Icons.logout, color: Colors.white54, size: 30),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            CarouselSlider(
              items: [
                Image.asset('assets/images/offer1.png'),
                Image.asset('assets/images/offer2.png'),
                Image.asset('assets/images/offer3.png'),
              ],
              options: CarouselOptions(autoPlay: true, viewportFraction: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Featured Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.5,
                ),
                itemCount: ProductModel.featuredProducts.length,
                itemBuilder: (context, index) {
                  final product = ProductModel.featuredProducts[index];
                  return Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: product.image ?? '',
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                          errorWidget:
                              (context, url, error) => const Icon(Icons.error),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('\$${product.price}'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            categories.isEmpty
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap:
                              () => navigateToProductsScreen(
                                context,
                                categories[index].id,
                                categories[index].name,
                              ),
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: categories[index].image ?? '',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (context, url) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                    errorWidget:
                                        (context, url, error) =>
                                            Center(child: Icon(Icons.error)),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                categories[index].name ?? '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: categories.length,
                  ),
                ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'New Arrivals',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.5,
                ),
                itemCount: ProductModel.newArrivals.length,
                itemBuilder: (context, index) {
                  final product = ProductModel.newArrivals[index];
                  return Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: product.image ?? '',
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                          errorWidget:
                              (context, url, error) => const Icon(Icons.error),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('\$${product.price.toStringAsFixed(2)}'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

