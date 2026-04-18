import 'package:flutter/material.dart';
import 'package:novastore/components/my_button.dart';
import 'package:novastore/services/cart_service.dart';

class CheckoutScreen extends StatefulWidget {
  final CartService cartService;

  const CheckoutScreen({
    super.key,
    required this.cartService,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedAddressIndex = 0;
  int _selectedPaymentMethod = 0;

  final List<Map<String, String>> _addresses = [
    {
      'title': 'Ev',
      'name': 'Ahmet Yılmaz',
      'address': 'Atatürk Cad. No: 123 Daire: 5',
      'city': 'Kadıköy, İstanbul',
      'phone': '+90 555 123 4567',
    },
    {
      'title': 'İş',
      'name': 'Ahmet Yılmaz',
      'address': 'Büyükdere Cad. Plaza No: 45',
      'city': 'Şişli, İstanbul',
      'phone': '+90 555 123 4567',
    },
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'type': 'card',
      'title': 'Kredi Kartı',
      'subtitle': '**** **** **** 1234',
      'icon': Icons.credit_card,
    },
    {
      'type': 'card',
      'title': 'Banka Kartı',
      'subtitle': '**** **** **** 5678',
      'icon': Icons.credit_card,
    },
    {
      'type': 'cash',
      'title': 'Kapıda Ödeme',
      'subtitle': 'Nakit veya Kredi Kartı',
      'icon': Icons.local_atm,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.cartService.totalPrice;
    final shipping = 15.00;
    final tax = subtotal * 0.18;
    final total = subtotal + shipping + tax;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Ödeme',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teslimat Adresi
            _buildSectionTitle('Teslimat Adresi'),
            _buildAddressList(),

            SizedBox(height: 24),

            // Ödeme Yöntemi
            _buildSectionTitle('Ödeme Yöntemi'),
            _buildPaymentMethodList(),

            SizedBox(height: 24),

            // Sipariş Özeti
            _buildSectionTitle('Sipariş Özeti'),
            _buildOrderSummary(subtotal, shipping, tax, total),

            SizedBox(height: 24),

            // Ürünler
            _buildSectionTitle('Ürünler (${widget.cartService.items.length})'),
            _buildProductList(),

            SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(total),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildAddressList() {
    return Column(
      children: [
        ..._addresses.asMap().entries.map((entry) {
          final index = entry.key;
          final address = entry.value;
          return _buildAddressCard(address, index);
        }).toList(),
        _buildAddNewAddressButton(),
      ],
    );
  }

  Widget _buildAddressCard(Map<String, String> address, int index) {
    final isSelected = _selectedAddressIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedAddressIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.location_on,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address['title']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (isSelected) ...[
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Seçili',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      address['name']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '${address['address']}, ${address['city']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      address['phone']!,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewAddressButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Yeni adres ekleme yakında eklenecek!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.border,
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                color: AppColors.primary,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Yeni Adres Ekle',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodList() {
    return Column(
      children: _paymentMethods.asMap().entries.map((entry) {
        final index = entry.key;
        final method = entry.value;
        return _buildPaymentMethodCard(method, index);
      }).toList(),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method, int index) {
    final isSelected = _selectedPaymentMethod == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPaymentMethod = index;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  method['icon'],
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      method['subtitle'],
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(
      double subtotal, double shipping, double tax, double total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildSummaryRow('Ara Toplam', subtotal),
            SizedBox(height: 12),
            _buildSummaryRow('Kargo', shipping),
            SizedBox(height: 12),
            _buildSummaryRow('KDV (%18)', tax),
            SizedBox(height: 16),
            Divider(color: AppColors.border),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Toplam',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.cartService.items.length,
          separatorBuilder: (context, index) => Divider(
            color: AppColors.border,
            height: 1,
          ),
          itemBuilder: (context, index) {
            final item = widget.cartService.items[index];
            return Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: AppColors.surface,
                      child: item.product.image != null
                          ? Image.network(
                              item.product.image!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.image,
                                    color: AppColors.textMuted);
                              },
                            )
                          : Icon(Icons.image, color: AppColors.textMuted),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Adet: ${item.quantity}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomBar(double total) {
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
      child: SafeArea(
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
                      'Toplam Tutar',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    onPressed: () {
                      _showOrderConfirmationDialog(total);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline,
                            color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Siparişi Onayla',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderConfirmationDialog(double total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 48,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Sipariş Onayı',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Siparişiniz başarıyla oluşturuldu!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Sipariş Tutarı',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dialog'u kapat
              Navigator.pop(context); // Checkout'u kapat
              Navigator.pop(context); // Cart'ı kapat
              widget.cartService.clearCart();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Text('Siparişiniz alındı! Teşekkür ederiz.'),
                    ],
                  ),
                  backgroundColor: AppColors.success,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Ana Sayfaya Dön',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
