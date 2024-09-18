import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_list/model/product_model.dart';

class ApiService {
  static const String baseUrl = "https://fakestoreapi.com/products";

  static Future<List<ProductModel>> fetchProducts(int start, int limit) async {
    final response = await http.get(Uri.parse('$baseUrl?start=$start&limit=$limit'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((e) => ProductModel(
        id: e['id'],
        name: e['title'],
        imageUrl: e['image'],
        price: double.parse(e['price'].toString()),
        description: e['description'],
      )).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}
