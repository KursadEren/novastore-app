import 'package:flutter/foundation.dart';
import '../models/product.dart';

class FavoritesService extends ChangeNotifier {
  final List<Product> _favorites = [];

  List<Product> get favorites => _favorites;

  int get favoriteCount => _favorites.length;

  bool isFavorite(int productId) {
    return _favorites.any((product) => product.id == productId);
  }

  void addToFavorites(Product product) {
    if (!isFavorite(product.id)) {
      _favorites.add(product);
      notifyListeners();
    }
  }

  void removeFromFavorites(int productId) {
    _favorites.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product.id)) {
      removeFromFavorites(product.id);
    } else {
      addToFavorites(product);
    }
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}
