import 'package:flutter/services.dart';

// Kart numarası formatter - "1234 5678 9012 3456" formatı
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Boşlukları temizle
    final text = newValue.text.replaceAll(' ', '');

    // 16 karakterden fazla girişi engelle
    if (text.length > 16) {
      return oldValue;
    }

    // 4'erli gruplar halinde boşluk ekle
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Son kullanma tarihi formatter - "MM/YY" formatı
class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Slash'i temizle
    final text = newValue.text.replaceAll('/', '');

    // 4 karakterden fazla girişi engelle (MMYY)
    if (text.length > 4) {
      return oldValue;
    }

    // 2 karakter sonra slash ekle
    if (text.length >= 2) {
      final month = text.substring(0, 2);
      final year = text.substring(2);
      final formatted = year.isEmpty ? month : '$month/$year';

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    return newValue;
  }
}

// CVV formatter - 3 haneli limit
class CVVFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 3 karakterden fazla girişi engelle
    if (newValue.text.length > 3) {
      return oldValue;
    }

    return newValue;
  }
}

// Büyük harf formatter (kart sahibi adı için)
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
