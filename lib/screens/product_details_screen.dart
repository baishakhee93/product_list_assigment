import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:product_list/model/product_model.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';



class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Favorite Icon on the top-right corner
              Stack(
                children: [
                  // Product Image
                  CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  // Favorite Icon Button (top-right)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<ProductProvider>(
                      builder: (context, provider, child) {
                        return IconButton(
                          icon: Icon(
                            product.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: product.isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () async {
                            // Toggle the favorite status in the provider
                            await provider.toggleFavorite(product);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Product Name
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Product Price
              Text(
                "\$${product.price}",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              // Product Description
              Text(
                product.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Like/Unlike Button
            ],
          ),
        ),
      ),
    );
  }
}
