import 'package:flutter/material.dart';
import 'package:novastore/components/my_button.dart';
import 'package:novastore/components/product_card.dart';
import 'package:novastore/pages/product_detail_screen.dart';
import 'package:novastore/services/cart_service.dart';
import 'package:novastore/services/favorites_service.dart';

class FavoritesScreen extends StatefulWidget {
  final CartService cartService;
  final FavoritesService favoritesService;
  final VoidCallback? onNavigateToCart;

  const FavoritesScreen({
    super.key,
    required this.cartService,
    required this.favoritesService,
    this.onNavigateToCart,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    widget.favoritesService.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    widget.favoritesService.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final favorites = widget.favoritesService.favorites;
    final hasFavorites = favorites.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Favorilerim ${hasFavorites ? "(${favorites.length})" : ""}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: hasFavorites
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: favorites[index],
                      favoritesService: widget.favoritesService,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                              product: favorites[index],
                              cartService: widget.cartService,
                              favoritesService: widget.favoritesService,
                              onNavigateToCart: widget.onNavigateToCart,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_outline,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Henüz Favori Ürün Yok',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 48.0),
                    child: Text(
                      'Beğendiğiniz ürünleri favorilerinize ekleyerek daha sonra kolayca bulabilirsiniz.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
