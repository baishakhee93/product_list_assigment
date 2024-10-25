import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import 'favorites_screen.dart';
import 'product_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  @override
  void initState() {
    super.initState();
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        productProvider.fetchProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
            Provider.of<ProductProvider>(context, listen: false).filterProducts(_searchQuery);

          },
          decoration: InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white60),
            icon: Icon(Icons.search, color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.white),

            onPressed: () {
              // Navigate to the FavoritesScreen to display favorite products
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              // Navigate to the FavoritesScreen to display favorite products
              _showFilterMenu(context);
            },
          ),
        ],
      ),
      body: Expanded(
        child: Consumer<ProductProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.products.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            // Filter products based on the search query
            final filteredProducts = provider.products.where((product) {
              return product.name.toLowerCase().contains(_searchQuery);
            }).toList();
            return ListView.builder(
              controller: _scrollController,
              itemCount: provider.filteredProducts.length + 1, // Use filteredProducts
              itemBuilder: (context, index) {
                if (index == provider.filteredProducts.length) {
                  return provider.hasMore
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox();
                }

                final product = provider.filteredProducts[index]; // Use filteredProducts

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsScreen(product: product),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                imageUrl: product.imageUrl,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Center(child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error, size: 50),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                                      SizedBox(height: 4),
                                      Text(
                                        "\$${product.price}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.green,
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
                  ),
                );
              },
            );

            /*  return ListView.builder(
              controller: _scrollController,
              itemCount: filteredProducts.length + 1,
              itemBuilder: (context, index) {
                if (index == filteredProducts.length) {
                  return provider.hasMore
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox();
                }

                final product = filteredProducts[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsScreen(product: product),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image
                              CachedNetworkImage(
                                imageUrl: product.imageUrl,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Center(child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error, size: 50),
                              ),

                              // Product Name and Price
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                                      SizedBox(height: 4),
                                      Text(
                                        "\$${product.price}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.green,
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
                  ),
                );
              },
            );*/
          },
        ),
      ),

    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search products...",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (query) {
          // TODO: Implement search functionality.
        },
      ),
    );
  }


  void _showFilterMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by Price'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Low to High'),
                onTap: () {
                  Navigator.of(context).pop();
                  _sortProductsByPrice(true);
                },
              ),
              ListTile(
                title: Text('High to Low'),
                onTap: () {
                  Navigator.of(context).pop();
                  _sortProductsByPrice(false);
                },
              ),
              ListTile(
                title: Text('Reset'),
                onTap: () {
                  Navigator.of(context).pop();
                  _resetFilters(); // Call the method to reset filters
                },
              ),
            ],
          ),
        );
      },
    );
  }

// Method to sort products by price
  void _sortProductsByPrice(bool lowToHigh) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    // Logic to sort products based on price
    productProvider.sortProductsByPrice(lowToHigh);
  }

// Method to reset filters
  void _resetFilters() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.resetFilters(); // Assuming you have a method in your provider
  }

}
