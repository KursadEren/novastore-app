import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';

class CartScreen extends StatelessWidget {
  final CartService cartService;

  const CartScreen({
    super.key,
    required this.cartService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text(
          'Sepetim',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (cartService.items.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Sepeti Temizle'),
                    content: Text('Tüm ürünleri sepetten kaldırmak istediğinize emin misiniz?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('İptal'),
                      ),
                      TextButton(
                        onPressed: () {
                          cartService.clearCart();
                          Navigator.pop(context);
                        },
                        child: Text('Temizle', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
        elevation: 0,
      ),
      body: cartService.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Sepetiniz Boş',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Alışverişe başlamak için ürünleri keşfedin!',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: cartService.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartService.items[index];
                      return _buildCartItem(context, cartItem);
                    },
                  ),
                ),
                _buildBottomBar(context),
              ],
            ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem cartItem) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ürün resmi
          ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.grey[100],
              child: cartItem.product.image != null
                  ? Image.network(
                      cartItem.product.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.image, color: Colors.grey[400]);
                      },
                    )
                  : Icon(Icons.image, color: Colors.grey[400]),
            ),
          ),

          // Ürün bilgileri
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    cartItem.product.category,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${cartItem.product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue[700],
                        ),
                      ),
                      // Miktar kontrolü
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, size: 18),
                              onPressed: () {
                                if (cartItem.quantity > 1) {
                                  cartService.updateQuantity(
                                    cartItem.product.id,
                                    cartItem.quantity - 1,
                                  );
                                } else {
                                  cartService.removeFromCart(cartItem.product.id);
                                }
                              },
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                            Text(
                              '${cartItem.quantity}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, size: 18),
                              onPressed: () {
                                cartService.updateQuantity(
                                  cartItem.product.id,
                                  cartItem.quantity + 1,
                                );
                              },
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Silme butonu
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey[600]),
            onPressed: () {
              cartService.removeFromCart(cartItem.product.id);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Toplam',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${cartService.totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ödeme sayfası yakında eklenecek!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Ödeme Yap',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
