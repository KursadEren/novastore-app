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
import 'package:novastore/services/favorites_service.dart';
import 'package:novastore/pages/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final CartService? cartService;
  final FavoritesService? favoritesService;

  const HomeScreen({super.key, this.cartService, this.favoritesService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  CartService? _cartService;
  FavoritesService? _favoritesService;
  List<Product> products = [];
  List<Product> filteredProducts = [];
  List<String> categories = [];
  bool isLoading = true;
  String? error;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _cartService = widget.cartService ?? CartService();
    _favoritesService = widget.favoritesService ?? FavoritesService();
    _favoritesService?.addListener(_onFavoritesChanged);
    _loadProducts();
  }

  @override
  void dispose() {
    _favoritesService?.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    setState(() {});
  }

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final fetchedProducts = await _productService.fetchProducts();

      // Kategorileri çıkar
      final categorySet = <String>{};
      for (var product in fetchedProducts) {
        categorySet.add(product.category);
      }

      final extractedCategories = categorySet.toList()..sort();
      debugPrint('📦 Toplam ${fetchedProducts.length} ürün yüklendi');
      debugPrint('🏷️ Kategoriler: $extractedCategories');

      setState(() {
        products = fetchedProducts;
        filteredProducts = fetchedProducts;
        categories = extractedCategories;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Ürünler yüklenemedi: $e';
        isLoading = false;
      });
    }
  }

  void _filterProducts(String? category) {
    setState(() {
      selectedCategory = category;
      if (category == null) {
        filteredProducts = products;
      } else {
        filteredProducts = products.where((product) {
          return product.category.toLowerCase() == category.toLowerCase();
        }).toList();
      }
    });
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
              categories: categories,
              onCategorySelected: (category) {
                _filterProducts(category);
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
                : filteredProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              selectedCategory != null
                                  ? 'Bu kategoride ürün bulunamadı'
                                  : 'Ürün bulunamadı',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
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
                                SizedBox(height: 16),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Size Özel Ürünler',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
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
                                    product: filteredProducts[index],
                                    favoritesService: _favoritesService,
                                    onTap: () {
                                      if (_cartService != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProductDetailScreen(
                                              product: filteredProducts[index],
                                              cartService: _cartService!,
                                              favoritesService: _favoritesService,
                                            ),
                                          ),
                                        ).then((_) => setState(() {}));
                                      }
                                    },
                                  );
                                },
                                childCount: filteredProducts.length,
                              ),
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }
}