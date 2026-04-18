import 'package:flutter/material.dart';
import 'package:novastore/components/my_button.dart';
import 'package:novastore/components/product_card.dart';
import 'package:novastore/components/banner_slider.dart';
import 'package:novastore/components/circle_category_banner.dart';
import 'package:novastore/components/category_chips.dart';
import 'package:novastore/components/search_input.dart';
import 'package:novastore/models/product.dart';
import 'package:novastore/services/product_service.dart';
import 'package:novastore/services/cart_service.dart';
import 'package:novastore/pages/product_detail_screen.dart';
import 'package:novastore/pages/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  final CartService? cartService;

  const HomeScreen({super.key, this.cartService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  late final CartService _cartService;
  List<Product> products = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _cartService = widget.cartService ?? CartService();
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
          icon: const Icon(Icons.menu, color: Colors.white),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: AppColors.primary,
            child: CategoryChips(
              onCategorySelected: (category) {
                debugPrint('Seçilen kategori: $category');
                // TODO: Kategori filtreleme implementasyonu
              },
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mail_outline, color: Colors.white),
            onPressed: () {
              debugPrint('Mesajlar tıklandı');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              debugPrint('Bildirimler tıklandı');
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
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
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${_cartService.itemCount}',
                      style: const TextStyle(
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
                    ? const Center(
                        child: Text('Ürün bulunamadı'),
                      )
                    : CustomScrollView(
                        slivers: [
                          const SliverToBoxAdapter(
                            child: Column(
                              children: [
                                SizedBox(height: 1),
                                SizedBox(
                                  height: 150,
                                  child: BannerSlider(),
                                ),
                                SizedBox(height: 10),
                                CircleCategoryBanner(),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            sliver: SliverGrid(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
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
                                childCount: products.length,
                              ),
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }
}