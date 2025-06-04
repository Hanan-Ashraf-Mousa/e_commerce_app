import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../network/firbase_manager.dart';

class OrdersScreen extends StatefulWidget {
  final String userId;

  const OrdersScreen({required this.userId, Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final FirebaseManager firebaseManager = FirebaseManager();
  late Future<List<OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = firebaseManager.getOrders(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      body: FutureBuilder<List<OrderModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders placed yet'));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text(
                      'Order #${order.id.substring(0, 6)} - ${order.status.toUpperCase()}'),
                  subtitle: Text(order.createdAt != null
                      ? 'Placed on ${order.createdAt!.toLocal().toString().split(' ')[0]}'
                      : 'Date not available'),
                  children: order.products
                      .map((product) => ListTile(
                    leading: product.image != null
                        ? Image.network(product.image!,
                        width: 40, height: 40, fit: BoxFit.cover)
                        : const Icon(Icons.image_not_supported),
                    title: Text(product.title),
                    subtitle:
                    Text('\$${product.price.toStringAsFixed(2)}'),
                  ))
                      .toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
