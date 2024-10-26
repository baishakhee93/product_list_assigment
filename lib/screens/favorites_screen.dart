import 'package:flutter/material.dart';
import 'package:product_list/screens/product_details_screen.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Products',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          // Filter the products to only show those that are marked as favorite
          final favoriteProducts = provider.products.where((product) => product.isFavorite).toList();

          if (favoriteProducts.isEmpty) {
            return Center(
              child: Text('No favorite products found.'),
            );
          }

          return ListView.builder(
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              final product = favoriteProducts[index];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: InkWell(
                  onTap: () {
                    // Navigate to product details if clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(product: product),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Product Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            product.imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        // Product details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "\$${product.price}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                product.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Favorite Button
                        IconButton(
                          icon: Icon(Icons.favorite, color: Colors.red),
                          onPressed: () async {
                            // Remove from favorites
                            await Provider.of<ProductProvider>(context, listen: false).toggleFavorite(product);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

