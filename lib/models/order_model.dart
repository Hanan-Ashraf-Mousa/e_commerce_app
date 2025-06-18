import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/models/product_model.dart';

class OrderModel {
  final String id;
  final List<ProductModel> products;
  final DateTime? createdAt;
  final String status;

  OrderModel({
    required this.id,
    required this.products,
    required this.createdAt,
    required this.status,
  });

  OrderModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json['id'] ?? '',
        products:
            (json['products'] as List<dynamic>?)
                ?.map((p) => ProductModel.fromJson(p))
                .toList() ??
            [],
        createdAt:
            json['createdAt'] != null
                ? (json['createdAt'] as Timestamp).toDate()
                : null,
        status: json['status'] ?? 'unknown',
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products': products.map((product) => product.toJson()),
      'status': status,
    };
  }
}
