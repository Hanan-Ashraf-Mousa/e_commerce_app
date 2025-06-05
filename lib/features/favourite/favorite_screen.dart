// import 'package:e_commerce_app/models/product_model.dart';
// import 'package:e_commerce_app/network/firbase_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../products/cart_screen.dart';
//
// class FavoriteScreen extends StatefulWidget {
//   FavoriteScreen({super.key});
//
//   @override
//   State<FavoriteScreen> createState() => _FavouriteScreenState();
// }
//
// class _FavouriteScreenState extends State<FavoriteScreen> {
//   List<ProductModel> favouriteItems = [];
//   String? userId;
//   bool isLoading = true;
//   String? error;
//
//   @override
//   void initState() {
//     super.initState();
//     _loaditems();
//   }
//
//   Future<void> _loaditems() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final id = prefs.getString('userId');
//       if (id == null) {
//         setState(() {
//           isLoading = false;
//           error = 'Please log in to view your cart';
//         });
//         return;
//       }
//       setState(() {
//         userId = id;
//       });
//       final items = await FirebaseManager().getFavoriteItems(id);
//       if (mounted) {
//         setState(() {
//           favouriteItems = items;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//           error = 'Failed to load cart: $e';
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Favourites',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//             color: Color(0xff06004F),
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
//             },
//             icon: Icon(Icons.shopping_cart_outlined, color: Color(0xff004081)),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemBuilder: (context, index) {
//                 final product = favouriteItems[index];
//                 return Container(
//                   margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: Color(0xff06004F)),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(20),
//                         child: Image.network(
//                           product.image ?? '',
//                           width: MediaQuery.of(context).size.width * 0.2,
//                           fit: BoxFit.cover,
//                           height: 100,
//                           loadingBuilder: (context, child, loadingProgress) {
//                             if (loadingProgress == null) return child;
//                             return CircularProgressIndicator();
//                           },
//                           errorBuilder: (context, e, stackTrace) {
//                             return Icon(Icons.error);
//                           },
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.6,
//                             child: Text(
//                               product.title,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                                 overflow: TextOverflow.ellipsis,
//                                 color: Color(0xff06004F),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 2),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Text(
//                                 'EGp ${product.price}',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                   color: Color(0xff06004F),
//                                 ),
//                               ),
//                               SizedBox(width: 5),
//                               ElevatedButton(
//                                 onPressed:()async{
//                                   final prefs = await SharedPreferences.getInstance();
//                                   final id = prefs.getString('userId');
//                                   await FirebaseManager().addToCart(product, id!);
//                                   Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));},
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color(0xff004182),
//                                   padding: const EdgeInsets.symmetric(vertical: 12),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                   children: [
//                                     Icon(
//                                       Icons.add_shopping_cart,
//                                       color: Colors.white,
//                                       size: 30,
//                                     ),
//                                     const Text(
//                                       'Add to Cart',
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           // Add to Cart Button
//                         ],
//                       ),
//                       IconButton(
//                         onPressed: () {
//
//                         },
//                         icon: Icon(Icons.favorite, color: Color(0xff004081)),
//                         hoverColor: Colors.red,
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               itemCount: favouriteItems.length,
//             ),
//           ),
//
//         ],
//       ),
//     );
//   }
//
// }
import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../network/firbase_manager.dart';

class FavoritesScreen extends StatefulWidget {
  final String userId;

  const FavoritesScreen({required this.userId, Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FirebaseManager firebaseManager = FirebaseManager();
  late Future<List<ProductModel>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = firebaseManager.getFavoriteItems(widget.userId);
  }

  void _removeFromFavorites(ProductModel product) async {
    try {
      await firebaseManager.removeFromFavorites(widget.userId, product.id);
      setState(() {
        _favoritesFuture = firebaseManager.getFavoriteItems(widget.userId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.title} removed from favorites')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to remove favorite')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Favorites')),
      body: FutureBuilder<List<ProductModel>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite products yet'));
          }
          final favorites = snapshot.data!;
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final product = favorites[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xff06004F)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        product.image ?? '',
                        width: MediaQuery.of(context).size.width * 0.2,
                        fit: BoxFit.cover,
                        height: 100,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return CircularProgressIndicator();
                        },
                        errorBuilder: (context, e, stackTrace) {
                          return Icon(Icons.error);
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              color: Color(0xff06004F),
                            ),
                          ),
                        ),
                        SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'EGp ${product.price}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff06004F),
                              ),
                            ),
                            SizedBox(width: 5,),
                            ElevatedButton(
                              onPressed: () async {
                                FirebaseManager().addToCart(product,widget.userId );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff004182),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 12
                                ),
                              ),
                              child: const Text(
                                'Add to Cart',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        _removeFromFavorites(product);
                      },
                      icon: Icon(Icons.favorite, color: Color(0xff004081)),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
