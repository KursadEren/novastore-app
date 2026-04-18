import 'package:flutter/material.dart';
import 'package:novastore/components/my_button.dart';
import 'package:novastore/services/cart_service.dart';

class CategoriesScreen extends StatelessWidget {
  final CartService cartService;

  const CategoriesScreen({
    super.key,
    required this.cartService,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Elektronik', 'icon': Icons.phone_android, 'color': Colors.blue},
      {'name': 'Moda', 'icon': Icons.checkroom, 'color': Colors.pink},
      {'name': 'Ev & Yaşam', 'icon': Icons.home, 'color': Colors.orange},
      {'name': 'Spor', 'icon': Icons.sports_soccer, 'color': Colors.green},
      {'name': 'Kitap', 'icon': Icons.book, 'color': Colors.purple},
      {'name': 'Kozmetik', 'icon': Icons.spa, 'color': Colors.red},
      {'name': 'Ayakkabı', 'icon': Icons.shop, 'color': Colors.brown},
      {'name': 'Aksesuar', 'icon': Icons.watch, 'color': Colors.teal},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Kategoriler',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${category['name']} kategorisi seçildi'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (category['color'] as Color).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          category['icon'] as IconData,
                          size: 40,
                          color: category['color'] as Color,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        category['name'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
