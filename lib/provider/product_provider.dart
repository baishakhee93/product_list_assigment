import 'package:flutter/material.dart';
import 'package:product_list/model/product_model.dart';
import '../services/api_service.dart';
import 'package:sqflite/sqflite.dart';


import 'package:path/path.dart';

class ProductProvider with ChangeNotifier {
  Database? _database;

  List<ProductModel> _products = [];
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
}

/*class ProductProvider with ChangeNotifier {
  Database? _database;

  List<ProductModel> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

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
  Future<void> initDatabase() async {
    _database = await openDatabase(
      'favorite_products.db',
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE favorites(id TEXT PRIMARY KEY)',
        );
      },
    );
  }
  Future<void> toggleFavorite(ProductModel product) async {
    if (product.isFavorite) {
      // Unmark as favorite (remove from SQLite)
      await _database?.delete('favorites', where: 'id = ?', whereArgs: [product.id]);
    } else {
      // Mark as favorite (insert into SQLite)
      await _database?.insert('favorites', {'id': product.id});
    }

    // Toggle the in-memory state and notify listeners
    product.isFavorite = !product.isFavorite;
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    // Fetch all favorite products from SQLite
    final favoriteIds = await _database?.query('favorites');
    final favoriteIdSet = favoriteIds?.map((e) => e['id'] as String).toSet() ?? {};

    // Mark products as favorite based on the IDs from SQLite
    _products.forEach((product) {
      product.isFavorite = favoriteIdSet.contains(product.id);
    });

    notifyListeners();
  }

  List<ProductModel> get products => _products;
  bool get isLoading => _loading;
}*/
