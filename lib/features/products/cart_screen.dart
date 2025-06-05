import 'package:e_commerce_app/features/products/order_screen.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/network/firbase_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];
  String? userId;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('userId');
      if (id == null) {
        setState(() {
          isLoading = false;
          error = 'Please log in to view your cart';
        });
        return;
      }
      setState(() {
        userId = id;
      });
      final items = await FirebaseManager().getCartItems(id);
      if (mounted) {
        setState(() {
          cartItems = items;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          error = 'Failed to load cart: $e';
        });
      }
    }
  }

  Future<void> _incrementQuantity(int index) async {
    if (userId == null) return;
    final product = cartItems[index]['product'] as ProductModel;
    final newQuantity = (cartItems[index]['quantity'] as int) + 1;
    try {
      await FirebaseManager().updateCartQuantity(
        userId!,
        product.id,
        newQuantity,
      );
      setState(() {
        cartItems[index]['quantity'] = newQuantity;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update quantity: $e')));
    }
  }

  Future<void> _decrementQuantity(int index) async {
    if (userId == null) return;
    final product = cartItems[index]['product'] as ProductModel;
    final currentQuantity = cartItems[index]['quantity'] as int;
    if (currentQuantity <= 1) return;
    final newQuantity = currentQuantity - 1;
    try {
      await FirebaseManager().updateCartQuantity(
        userId!,
        product.id,
        newQuantity,
      );
      setState(() {
        cartItems[index]['quantity'] = newQuantity;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update quantity: $e')));
    }
  }

  Future<void> _removeItem(int index) async {
    if (userId == null) return;
    final product = cartItems[index]['product'] as ProductModel;
    try {
      await FirebaseManager().removeFromCart(userId!, product.id);
      setState(() {
        cartItems.removeAt(index);
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to remove item: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xff06004F),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.shopping_cart_outlined, color: Color(0xff004081)),
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : cartItems.isEmpty
              ? Center(
                child: Text(
                  'No Products Added To Cart',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff06004F),
                  ),
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final product =
                            cartItems[index]['product'] as ProductModel;
                        final quantity = cartItems[index]['quantity'] as int;
                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 5,
                          ),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  fit: BoxFit.cover,
                                  height: 100,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'EGp ${product.price}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff06004F),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.35,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          color: Color(0xff004081),
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                _decrementQuantity(index);
                                              },
                                              icon: const Icon(
                                                Icons.remove_circle_outline,
                                                size: 25,
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
                                              onPressed: () {
                                                _incrementQuantity(index);
                                              },
                                              icon: const Icon(
                                                Icons.add_circle_outline,
                                                size: 25,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Add to Cart Button
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  _removeItem(index);
                                },
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Color(0xff004081),
                                ),
                                hoverColor: Colors.red,
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: cartItems.length,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
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
                              'EGp $totalPrice',
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
                            onPressed: () {
                              FirebaseManager().placeOrder(
                                userId!,
                                cartItems
                                    .map((item) => ProductModel.fromJson(item))
                                    .toList(),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          OrdersScreen(userId: userId!),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff004182),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  'Checkout',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  double get totalPrice => cartItems.fold(
    0,
    (sum, item) =>
        sum +
        (item['product'] as ProductModel).price * (item['quantity'] as int),
  );
}
