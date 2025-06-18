import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/features/products/product_details.dart';
import 'package:e_commerce_app/network/firbase_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/product_model.dart';

class ProductsCategoryScreen extends StatefulWidget {
  static const routeName = '/products';

  const ProductsCategoryScreen({super.key});

  @override
  State<ProductsCategoryScreen> createState() => _ProductsCategoryScreenState();
}

class _ProductsCategoryScreenState extends State<ProductsCategoryScreen> {
  String? userId;
  Map<String, bool> favoriteStatus = {};
  Map<String, bool> isLoading = {};

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFavorites();
  }

  Future<void> _loadUserIdAndFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });

    if (userId != null) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final List<ProductModel> products =
          args['products'] as List<ProductModel>;
      for (var product in products) {
        favoriteStatus[product.id] = await FirebaseManager().isFavorite(
          userId!,
          product.id,
        );
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final List<ProductModel> products = args['products'] as List<ProductModel>;
    final String categoryName = args['categoryName'] as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xff004182),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white70),
        ),
      ),
      body:userId == null
              ? const Center(child: Text('Please log in to view products'))
              : products.isEmpty
              ? const Center(
                child: Text(
                  'No products Found for this Category',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
              : GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: product.image ?? '',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  placeholder:
                                      (context, url) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                  errorWidget:
                                      (context, url, error) =>
                                          const Icon(Icons.error),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    if (userId == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Please log in to manage favorites')),
                                      );
                                      return;
                                    }

                                    setState(() {
                                      isLoading[product.id] = true;
                                    });

                                    try {
                                      if (favoriteStatus[product.id] ?? false) {
                                        await FirebaseManager().removeFromFavorites(userId!, product.id);
                                        favoriteStatus[product.id] = false;
                                      } else {
                                        await FirebaseManager().addToFavorites(product, userId!);
                                        favoriteStatus[product.id] = true;
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error: $e')),
                                      );
                                    } finally {
                                      setState(() {
                                        isLoading[product.id] = false;
                                      });
                                    }
                                  },
                                  icon: isLoading[product.id] == true
                                      ? const CircularProgressIndicator()
                                      : Icon(
                                    (favoriteStatus[product.id] ?? false)
                                        ? Icons.favorite
                                        : Icons.favorite_border_outlined,
                                    color: const Color(0xff004182),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '\$${product.price}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
