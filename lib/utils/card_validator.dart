class CardValidator {
  // Kart numarası validasyonu (16 haneli + Luhn algoritması)
  static String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kart numarası gereklidir';
    }

    // Boşlukları temizle
    final cardNumber = value.replaceAll(' ', '');

    // 16 haneli mi kontrol et
    if (cardNumber.length != 16) {
      return 'Geçerli bir kart numarası girin (16 haneli)';
    }

    // Sadece rakamlardan oluşuyor mu
    if (!RegExp(r'^\d+$').hasMatch(cardNumber)) {
      return 'Kart numarası sadece rakam içerebilir';
    }

    // Luhn algoritması kontrolü
    if (!_luhnCheck(cardNumber)) {
      return 'Geçersiz kart numarası';
    }

    return null; // Geçerli
  }

  // Kart sahibi adı validasyonu
  static String? validateCardholderName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kart sahibinin adını girin';
    }

    // Trim ve büyük harfe çevir
    final name = value.trim();

    // En az 2 kelime olmalı (ad ve soyad)
    final words = name.split(' ').where((word) => word.isNotEmpty).toList();
    if (words.length < 2) {
      return 'En az ad ve soyad gerekli';
    }

    // Sadece harfler ve boşluk olmalı
    if (!RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s]+$').hasMatch(name)) {
      return 'Sadece harf kullanılabilir';
    }

    return null; // Geçerli
  }

  // Son kullanma tarihi validasyonu (MM/YY formatı)
  static String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Son kullanma tarihini girin (MM/YY)';
    }

    // Slash'i temizle ve kontrol et
    final parts = value.split('/');
    if (parts.length != 2) {
      return 'Geçersiz format (MM/YY olmalı)';
    }

    final month = parts[0];
    final year = parts[1];

    // Uzunluk kontrolü
    if (month.length != 2 || year.length != 2) {
      return 'Geçersiz format (MM/YY olmalı)';
    }

    // Sayı kontrolü
    final monthInt = int.tryParse(month);
    final yearInt = int.tryParse(year);

    if (monthInt == null || yearInt == null) {
      return 'Geçersiz tarih';
    }

    // Ay 1-12 arası olmalı
    if (monthInt < 1 || monthInt > 12) {
      return 'Geçersiz ay (01-12 arası olmalı)';
    }

    // Gelecek tarih kontrolü
    if (!_isFutureDate(monthInt, yearInt)) {
      return 'Kart süresi dolmuş';
    }

    return null; // Geçerli
  }

  // CVV validasyonu
  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV kodunu girin';
    }

    // Tam 3 haneli olmalı
    if (value.length != 3) {
      return 'CVV 3 haneli olmalıdır';
    }

    // Sadece rakam olmalı
    if (!RegExp(r'^\d{3}$').hasMatch(value)) {
      return 'CVV sadece rakam içerebilir';
    }

    return null; // Geçerli
  }

  // Luhn algoritması implementasyonu
  static bool _luhnCheck(String cardNumber) {
    int sum = 0;
    bool alternate = false;

    // Sağdan sola git
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return (sum % 10) == 0;
  }

  // Gelecek tarih kontrolü
  static bool _isFutureDate(int month, int year) {
    final now = DateTime.now();
    final currentYear = now.year % 100; // Son 2 hane
    final currentMonth = now.month;

    // Yıl kontrolü
    if (year < currentYear) {
      return false;
    }

    // Aynı yıldaysa ay kontrolü
    if (year == currentYear && month < currentMonth) {
      return false;
    }

    return true;
  }
}
