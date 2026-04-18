import 'package:flutter/material.dart';

class CircleCategoryBanner extends StatelessWidget {
  const CircleCategoryBanner({super.key});

  final List<Map<String, String>> _categories = const [
    {
      'title': 'Elektronik',
      'image': 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=400',
    },
    {
      'title': 'Moda',
      'image': 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=400',
    },
    {
      'title': 'Ev & Yaşam',
      'image': 'https://images.unsplash.com/photo-1556912173-46c336c7fd55?w=400',
    },
    {
      'title': 'Spor',
      'image': 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=400',
    },
    {
      'title': 'Kozmetik',
      'image': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
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
                // Circle container with image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      category['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[600],
                            size: 32,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.grey[400]!,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 6),
                // Category title
                SizedBox(
                  width: 70,
                  child: Text(
                    category['title']!,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
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
