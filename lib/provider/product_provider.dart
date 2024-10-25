import 'package:flutter/material.dart';
import 'package:product_list/model/product_model.dart';
import '../services/api_service.dart';
import 'package:sqflite/sqflite.dart';


import 'package:path/path.dart';
class ProductProvider with ChangeNotifier {
  Database? _database;

  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = []; // Filtered products

  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;

  // Getters for products, filtered products, loading state, and pagination flag
  List<ProductModel> get products => _products;
  List<ProductModel> get filteredProducts => _filteredProducts; // Added getter for filtered products
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  // Initialize SQLite database
  Future<void> initDatabase() async {
    String dbPath = await getDatabasesPath();
    _database = await openDatabase(
      join(dbPath, 'favorite_products.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE favorites(id TEXT PRIMARY KEY)',
        );
      },
    );
    // Load favorite products from the database on initialization
    await loadFavorites();
  }

  // Fetch products from API with pagination
  Future<void> fetchProducts() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      List<ProductModel> newProducts = await ApiService.fetchProducts(_currentPage * 10, 10);
      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        _products.addAll(newProducts);
        _filteredProducts = List.from(_products); // Initialize filtered products
        _currentPage++;
      }
    } catch (e) {
      _hasMore = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  void filterProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = List.from(products); // Reset to all products
    } else {
      _filteredProducts = products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners(); // Notify listeners to update UI
  }
  // Toggle the favorite status of a product and update SQLite
  Future<void> toggleFavorite(ProductModel product) async {
    if (product.isFavorite) {
      await _database?.delete('favorites', where: 'id = ?', whereArgs: [product.id]);
    } else {
      await _database?.insert('favorites', {'id': product.id});
    }

    product.isFavorite = !product.isFavorite;
    notifyListeners();
  }

  // Load favorite products from SQLite and update the product list
  Future<void> loadFavorites() async {
    final favoriteIds = await _database?.query('favorites');
    final favoriteIdSet = favoriteIds?.map((e) => e['id'] as String).toSet() ?? {};

    for (var product in _products) {
      product.isFavorite = favoriteIdSet.contains(product.id);
    }

    notifyListeners();
  }

  // Clear the list and reset pagination
  void resetProducts() {
    _products = [];
    _filteredProducts = []; // Also reset filtered products
    _currentPage = 0;
    _hasMore = true;
    notifyListeners();
  }

  // Sort products by price and update filtered products
  void sortProductsByPrice(bool lowToHigh) {
    _filteredProducts = List.from(_products); // Start with the original product list
    _filteredProducts.sort((a, b) {
      return lowToHigh ? a.price.compareTo(b.price) : b.price.compareTo(a.price);
    });
    notifyListeners();
  }

  // Reset filters
  void resetFilters() {
    _filteredProducts = List.from(_products); // Reset filtered products to original
    notifyListeners();
  }

  List<ProductModel> _cartItems = []; // Cart items list

  List<ProductModel> get cartItems => _cartItems;

  // Method to add product to the cart
  void addToCart(ProductModel product) {
    // Check if the product is already in the cart
    if (!_cartItems.contains(product)) {
      _cartItems.add(product);
      notifyListeners(); // Notify listeners about the change
    } else {
      // Optionally, you could show a message that the item is already in the cart
      // e.g., show a SnackBar or dialog
    }
  }

  double get totalAmount {
    double total = 0;
    for (var item in _cartItems) {
      total += item.price * 1; // Calculate total based on quantity
    }
    return total;
  }

}

/*class ProductProvider with ChangeNotifier {
  Database? _database;

  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = []; // Filtered products

  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;

  // Getters for products, loading state, and pagination flag
  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  // Initialize SQLite database
  Future<void> initDatabase() async {
    String dbPath = await getDatabasesPath();
    _database = await openDatabase(
      join(dbPath, 'favorite_products.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE favorites(id TEXT PRIMARY KEY)',
        );
      },
    );
    // Load favorite products from the database on initialization
    await loadFavorites();
  }

  // Fetch products from API with pagination
  Future<void> fetchProducts() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      List<ProductModel> newProducts = await ApiService.fetchProducts(_currentPage * 10, 10);
      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        _products.addAll(newProducts);
        _currentPage++;
      }
    } catch (e) {
      _hasMore = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle the favorite status of a product and update SQLite
  Future<void> toggleFavorite(ProductModel product) async {
    if (product.isFavorite) {
      // Unmark as favorite (remove from SQLite)
      await _database?.delete('favorites', where: 'id = ?', whereArgs: [product.id]);
    } else {
      // Mark as favorite (insert into SQLite)
      await _database?.insert('favorites', {'id': product.id});
    }

    // Toggle the in-memory favorite status and notify listeners
    product.isFavorite = !product.isFavorite;
    notifyListeners();
  }

  // Load favorite products from SQLite and update the product list
  Future<void> loadFavorites() async {
    final favoriteIds = await _database?.query('favorites');
    final favoriteIdSet = favoriteIds?.map((e) => e['id'] as String).toSet() ?? {};

    // Update favorite status based on SQLite data
    for (var product in _products) {
      product.isFavorite = favoriteIdSet.contains(product.id);
    }

    notifyListeners();
  }

  // Clear the list and reset pagination
  void resetProducts() {
    _products = [];
    _currentPage = 0;
    _hasMore = true;
    notifyListeners();
  }

  void sortProductsByPrice(bool lowToHigh) {
    _filteredProducts.sort((a, b) {
      return lowToHigh ? a.price.compareTo(b.price) : b.price.compareTo(a.price);
    });
    notifyListeners();
  }

  void resetFilters() {
    _filteredProducts = List.from(_products); // Reset filtered products to original
    notifyListeners();
  }}*/

