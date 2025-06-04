import 'package:e_commerce_app/features/products/product_details.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:flutter/material.dart';

class MySearchDelegate extends SearchDelegate<String> {
  final List<ProductModel> products;
  MySearchDelegate({required this.products});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List results =
        products
            .where(
              (product) =>
                  product.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          onTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProductDetailsScreen(product: results[index])));
          },
          title: Text(results[index].title),
          leading: Image.network(results[index].image,
          loadingBuilder: (context,child,loadingProgress){
            if(loadingProgress == null) return child;
            return CircularProgressIndicator();
          },
          errorBuilder: (context,e,stackTrace){
            return Icon(Icons.error);
          },),
        );
      },
      itemCount: results.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List suggestions =
        products
            .where(
              (product) =>
                  product.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          onTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProductDetailsScreen(product: suggestions[index])));
          },
          title: Text(suggestions[index].title),
          leading: Image.network(suggestions[index].image,
            loadingBuilder: (context,child,loadingProgress){
              if(loadingProgress == null) return child;
              return CircularProgressIndicator();
            },
            errorBuilder: (context,e,stackTrace){
              return Icon(Icons.error);
            },),
        );
      },
      itemCount: suggestions.length,
    );
  }

}
