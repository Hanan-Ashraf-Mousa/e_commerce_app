import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/category_model.dart';
import '../models/product_model.dart';

class ApiManger{
  static Future<List<CategoryModel>> getCategories() async {
    var url = Uri.parse('https://ecommerce.routemisr.com/api/v1/categories');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<CategoryModel> categories = (data['data'] as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }
  static Future<List<ProductModel>> getProducts() async {
    var url = Uri.parse('https://ecommerce.routemisr.com/api/v1/products');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List products = data['data'];

        List<ProductModel> productList =
        products.map((product) => ProductModel.fromJson(product)).toList();
        return productList;
      }else {
        throw Exception(
            'Failed to load products');
      } }catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
  static Future<List<ProductModel>> getProductsOnSpecificCategory(
      String categoryId) async {
    try {

        List<ProductModel> productList = await getProducts();

        List<ProductModel> filteredList = productList
            .where((product) => product.category!.id== categoryId)
            .toList();
        return filteredList;
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load products: $e');
    }
  }

}