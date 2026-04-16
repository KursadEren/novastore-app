import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/product.dart';

class ProductService {
  static String get baseUrl => dotenv.env['API_URL'] ?? 'https://dummyjson.com';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final productResponse = ProductResponse.fromJson(data);
      return productResponse.products;
    } else {
      throw Exception('Ürünler yüklenemedi: ${response.statusCode}');
    }
  }
}
