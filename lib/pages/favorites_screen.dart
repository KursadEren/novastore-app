import 'package:flutter/material.dart';
import 'package:novastore/components/my_button.dart';
import 'package:novastore/services/cart_service.dart';

class FavoritesScreen extends StatefulWidget {
  final CartService cartService;

  const FavoritesScreen({
    super.key,
    required this.cartService,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Favorilerim',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite_outline,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Henüz Favori Ürün Yok',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: Text(
                  'Beğendiğiniz ürünleri favorilerinize ekleyerek daha sonra kolayca bulabilirsiniz.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: MyButton(
                  text: 'Alışverişe Başla',
                  onPressed: () {
                    // Ana sayfaya dön (index 0)
                    // Bu, BottomBar'daki currentIndex'i değiştirerek yapılabilir
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
