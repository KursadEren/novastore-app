import 'package:flutter/material.dart';
import 'package:novastore/components/my_button.dart';

class CategoryChips extends StatefulWidget {
  final Function(String?)? onCategorySelected;
  final List<String>? categories;

  const CategoryChips({
    super.key,
    this.onCategorySelected,
    this.categories,
  });

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final allCategories = ['Tümü', ...(widget.categories ?? [])];

    debugPrint('🔖 CategoryChips - Gösterilen kategoriler: $allCategories');

    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          final category = allCategories[index];
          final isSelected = selectedCategory == category ||
                           (selectedCategory == null && category == 'Tümü');

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedCategory = category == 'Tümü' ? null : category;
                });
                widget.onCategorySelected?.call(selectedCategory);
              },
              backgroundColor: AppColors.primary,
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
