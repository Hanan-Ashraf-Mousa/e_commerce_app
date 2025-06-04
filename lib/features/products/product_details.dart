import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/features/products/cart_screen.dart';
import 'package:e_commerce_app/network/firbase_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = '/product-details';
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsScreen> {
  int quantity = 1;
  bool isLoading = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }
  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('userId');
    if (id != null && mounted) {
      setState(() {
        userId = id;
      });
    }
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xff06004F),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
            },
            icon: Icon(Icons.shopping_cart_outlined, color: Color(0xff004081)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.indigo),
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: product.image ?? '',
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                      errorWidget:
                          (context, url, error) =>
                              const Center(child: Icon(Icons.error, size: 50)),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_border_outlined,
                      size: 40,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff06004F),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Description',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff06004F),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    product.description ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff06004F),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'EGp ${product.price}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff06004F),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xff004081),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: _decrementQuantity,
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '$quantity',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: _incrementQuantity,
                              icon: const Icon(
                                Icons.add_circle_outline,
                                size: 35,
                                color: Colors.white,
                              ),
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Total Price',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff06004F).withOpacity(0.6),
                            ),
                          ),
                          Text(
                            'EGp ${quantity * product.price}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff06004F),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:()async{
                            _addToCart();
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff004182),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.add_shopping_cart,
                                color: Colors.white,
                                size: 30,
                              ),
                              const Text(
                                'Add to Cart',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _addToCart() async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add to cart')),
      );
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      final productWithQuantity = widget.product..quantity = quantity;
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('userId');
      await FirebaseManager().addToCart(productWithQuantity, id!);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.product.title} (x$quantity) added to cart!'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding to cart: $e')),
        );
      }
    }
  }
}
