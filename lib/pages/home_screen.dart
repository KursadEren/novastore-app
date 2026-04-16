import 'package:flutter/material.dart';
import 'package:novastore/components/my_button.dart';
import 'package:novastore/components/product_card.dart';
import 'package:novastore/components/banner_slider.dart';
import 'package:novastore/components/circle_category_banner.dart';
import 'package:novastore/components/search_input.dart';
import 'package:novastore/models/product.dart';
import 'package:novastore/services/product_service.dart';
import 'package:novastore/services/cart_service.dart';
import 'package:novastore/pages/product_detail_screen.dart';
import 'package:novastore/pages/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();
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

    try {
      final fetchedProducts = await _productService.fetchProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Ürünler yüklenemedi: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            debugPrint('Menü açıldı');
          },
        ),
        title: SearchInput(
          hintText: 'Ürün ara...',
          onChanged: (value) {
            debugPrint('Arama: $value');
          },
          onSubmitted: (value) {
            debugPrint('Arama yapıldı: $value');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.mail_outline, color: Colors.white),
            onPressed: () {
              debugPrint('Mesajlar tıklandı');
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              debugPrint('Bildirimler tıklandı');
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(cartService: _cartService),
                    ),
                  ).then((_) => setState(() {}));
                },
              ),
              if (_cartService.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${_cartService.itemCount}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
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
                          CircleCategoryBanner(),
                          SizedBox(height: 16),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  return ProductCard(
                                    product: products[index],
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetailScreen(
                                            product: products[index],
                                            cartService: _cartService,
                                          ),
                                        ),
                                      ).then((_) => setState(() {}));
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