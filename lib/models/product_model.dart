import 'package:e_commerce_app/models/category_model.dart';

class ProductModel {
  final String id;
  final String title;
  final double price;
  final String? image;
  final String? description;
  final CategoryModel? category;
  int quantity;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    this.image,
    this.description,
    this.category,
    this.quantity = 1,
  });

  static List<ProductModel> featuredProducts = [
    ProductModel(
      id: '4',
      title:
      'EOS M50 Mark II Mirrorless Digital Camera With EF15-45mm Lens Black',
      price: 19699,
      image:
      "https://ecommerce.routemisr.com/Route-Academy-products/1678304313006-cover.jpeg",
    ),
    ProductModel(
      id: '5',
      title: 'Archer VR300 AC1200 Wireless VDSL/ADSL Modem Router Black',
      price: 1699,
      image:
      "https://ecommerce.routemisr.com/Route-Academy-products/1678305677165-cover.jpeg",
    ),
    ProductModel(
      id: '1',
      title: 'Woman Shawl',
      price: 191,
      image:
      "https://ecommerce.routemisr.com/Route-Academy-products/1680403397402-cover.jpeg",
    ),
    ProductModel(
      id: '2',
      title: 'Woman Standart Fit Knitted Cardigan',
      price: 499,
      image:
      "https://ecommerce.routemisr.com/Route-Academy-products/1680401893316-cover.jpeg",
    ),
    ProductModel(
      id: '3',
      title: 'Softride Enzo NXT CASTLEROCK-High Risk R',
      price: 2999,
      image:
      "https://ecommerce.routemisr.com/Route-Academy-products/1680399913757-cover.jpeg",
    ),
  ];

  static List<ProductModel> newArrivals = [
    ProductModel(
      id: '1',
      title: 'Woman Shawl',
      price: 191,
      image:
      "https://ecommerce.routemisr.com/Route-Academy-products/1680403397402-cover.jpeg",
    ),
    ProductModel(
      id: '2',
      title: 'Woman Standart Fit Knitted Cardigan',
      price: 499,
      image:
      "https://ecommerce.routemisr.com/Route-Academy-products/1680401893316-cover.jpeg",
    ),
    ProductModel(
      id: '3',
      title: 'Softride Enzo NXT CASTLEROCK-High Risk R',
      price: 2999,
      image:
      "https://ecommerce.routemisr.com/Route-Academy-products/1680399913757-cover.jpeg",
    ),
    ProductModel(
      id: '4',
      title:
      'EOS M50 Mark II Mirrorless Digital Camera With 15-45mm Lens Black',
      price: 19699,
      image:
      "https://ecommerce.routemisr.com/Route-Academy-products/1678304313006-cover.jpeg",
    ),
    ProductModel(
      id: '5',
      title: 'Archer VR300 AC1200 Wireless VDSL/ADSL Modem Router Black',
      price: 1699,
      image:
      "https://ecommerce.routemisr.com/Route-Academy-products/1678305677165-cover.jpeg",
    ),
  ];

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['imageCover'],
      description: json['description'],
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'imageCover': image,
      'description': description,
      'category': category?.toJson(),
      'quantity': quantity,
    };
  }

  }