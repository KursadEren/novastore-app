import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/product.dart';

class ProductService {
  // Base URL - .env dosyasından alınıyor
  static String get baseUrl => dotenv.env['API_URL'] ?? 'https://dummyjson.com';

  // API endpoint
  static const String productsEndpoint = '/products';

  // HTTP client instance
  final http.Client client;

  // Constructor
  ProductService({http.Client? client}) : client = client ?? http.Client();

  // Response değişkenleri
  ProductResponse? _productResponse;
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  ProductResponse? get productResponse => _productResponse;
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Tüm ürünleri getir
  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;

    try {
      final url = Uri.parse('$baseUrl$productsEndpoint');
      print('API URL: $url'); // Debug

      final response = await client.get(url);
      print('Status Code: ${response.statusCode}'); // Debug
      print('Response Body: ${response.body.substring(0, 200)}...'); // Debug

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _productResponse = ProductResponse.fromJson(jsonData);
        _products = _productResponse!.products;
        print('Products loaded: ${_products.length}'); // Debug
      } else {
        _error = 'Ürünler yüklenemedi: ${response.statusCode}';
      }
    } catch (e) {
      print('Error: $e'); // Debug
      _error = 'Bağlantı hatası: $e';
    } finally {
      _isLoading = false;
    }
  }

  // Dispose
  void dispose() {
    client.close();
  }
}
