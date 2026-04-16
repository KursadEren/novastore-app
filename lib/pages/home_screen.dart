import 'package:flutter/material.dart';
import 'package:novastore/components/my_button.dart';
import 'package:novastore/components/product_card.dart';
import 'package:novastore/components/banner_slider.dart';
import 'package:novastore/models/product.dart';
import 'package:novastore/services/product_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  List<Product> products = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    await _productService.fetchProducts();

    setState(() {
      products = _productService.products;
      isLoading = _productService.isLoading;
      error = _productService.error;
    });
  }

  @override
  void dispose() {
    _productService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'NovaStore',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              )
            : error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red,
                        ),
                        SizedBox(height: 16),
                        Text(
                          error!,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        MyButton(
                          text: 'Tekrar Dene',
                          onPressed: _loadProducts,
                        ),
                      ],
                    ),
                  )
                : products.isEmpty
                    ? Center(
                        child: Text('Ürün bulunamadı'),
                      )
                    : Column(
                        children: [
                          SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: BannerSlider(),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  return ProductCard(
                                    product: products[index],
                                    onTap: () {
                                      debugPrint('Tapped: ${products[index].title}');
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }
}