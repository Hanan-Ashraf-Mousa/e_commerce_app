import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/features/products/product_details.dart';
import 'package:e_commerce_app/network/api_manager.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: FutureBuilder(future: ApiManger.getProducts(), builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }else if(snapshot.hasError){
          return Center(child: Text('Some thing went wrong'),);
        }else{
          if(snapshot.data!.isEmpty){
            return Center(child: Text('No products Found'),);
          }else{
            final products = snapshot.data;
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.75,
              ),
              itemCount: products?.length,
              itemBuilder: (context, index) {
                final product = products?[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                            ProductDetailsScreen(product: product!),
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
                                imageUrl: product!.image ?? '',
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
                              // IconButton(
                              //   onPressed: () async {
                              //     if (userId == null) {
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(content: Text('Please log in to manage favorites')),
                              //       );
                              //       return;
                              //     }
                              //
                              //     setState(() {
                              //       isLoading[product.id] = true;
                              //     });
                              //
                              //     try {
                              //       if (favoriteStatus[product.id] ?? false) {
                              //         await FirebaseManager().removeFromFavorites(userId!, product.id);
                              //         favoriteStatus[product.id] = false;
                              //       } else {
                              //         await FirebaseManager().addToFavorites(product, userId!);
                              //         favoriteStatus[product.id] = true;
                              //       }
                              //     } catch (e) {
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(content: Text('Error: $e')),
                              //       );
                              //     } finally {
                              //       setState(() {
                              //         isLoading[product.id] = false;
                              //       });
                              //     }
                              //   },
                              //   icon: isLoading[product.id] == true
                              //       ? const CircularProgressIndicator()
                              //       : Icon(
                              //     (favoriteStatus[product.id] ?? false)
                              //         ? Icons.favorite
                              //         : Icons.favorite_border_outlined,
                              //     color: const Color(0xff004182),
                              //   ),
                              // ),
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
            );
          }
        }
      }),
    );
  }
}
