import 'package:flutter/material.dart';

class CircleCategoryBanner extends StatelessWidget {
  const CircleCategoryBanner({super.key});

  final List<Map<String, dynamic>> _categories = const [
    {
      'title': 'Kategori 1',
      'color': Colors.blue,
    },
    {
      'title': 'Kategori 2',
      'color': Colors.green,
    },
    {
      'title': 'Kategori 3',
      'color': Colors.orange,
    },
    {
      'title': 'Kategori 4',
      'color': Colors.purple,
    },
    {
      'title': 'Kategori 5',
      'color': Colors.pink,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circle container
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: category['color'],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.category,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                // Category title
                SizedBox(
                  width: 80,
                  child: Text(
                    category['title'],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
