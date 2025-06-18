import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/product_model.dart';
import '../../network/firbase_manager.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String,dynamic>> products;
  final double totalPrice ;
  const CheckoutScreen({super.key, required this.products ,required this.totalPrice });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}


class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isLoading = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  Future<void> _processPayment() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (userId != null) {
        final products =widget.products.map((product)=>ProductModel.fromJson(product)).toList();
        await FirebaseManager().placeOrder(userId!, products);
        await FirebaseManager().clearCart(userId!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully!')),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff004182),
      ),
      body: userId == null
          ? const Center(child: Text('Please log in to checkout'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  final product = widget.products[index]['product'] as ProductModel;
                  final quantity = widget.products[index]['quantity'] as int ;
                  return  Container(
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
                                  child:Text(
                                    '$quantity',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Add to Cart Button
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Text('Total: \$${widget.totalPrice}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Shipping Address'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : _processPayment,
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xff004081)),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Complete Payment', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}