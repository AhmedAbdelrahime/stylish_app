import 'package:flutter/material.dart';

enum StoreProductType { clothes, shoes }

class StoreConfig {
  const StoreConfig._();

  static const brandName = 'Stylish';
  static const countryName = 'Egypt';
  static const countryCode = 'EG';

  static const supportedProductTypes = <StoreProductType>[
    StoreProductType.clothes,
    StoreProductType.shoes,
  ];

  static const standardDeliveryFee = 50.0;
  static const minDeliveryDays = 1;
  static const maxDeliveryDays = 3;
  static const defaultDeliveryWindowLabel = '1-3 business days';

  static const currencyCode = 'EGP';
  static const currencySymbol = 'EGP';
  static const budgetFilterAmount = 500.0;

  // Keep false for stores that do not maintain exact inventory in Supabase.
  static const enforceStockQuantity = false;

  // Turn on only after the Supabase fashion migration is applied, or after
  // every product has sizes saved in the database.
  static const useFallbackSizesWhenProductSizesMissing = false;
}

class StoreAssets {
  const StoreAssets._();

  static const logo = 'assets/logo/logo.svg';
  static const appIcon = 'assets/logo/app_icon.png';
  static const fallbackProfileImage = 'assets/images/profile.png';
  static const defaultProductImage = 'assets/images/fashion_shop.png';
  static const productImageFallback = 'assets/images/cat.png';
  static const getStartedBackground = 'assets/images/get_start.png';
  static const couponIcon = 'assets/svgs/coupon.svg';
  static const successIcon = 'assets/svgs/success.svg';
  static const locationIcon = 'assets/svgs/location.svg';
  static const editIcon = 'assets/svgs/edit.svg';
  static const menuIcon = 'assets/svgs/menu.svg';
  static const logoutIcon = 'assets/svgs/logout.svg';
  static const deleteCardIcon = 'assets/svgs/deleteCard.svg';
  static const sortIcon = 'assets/svgs/sort.svg';
  static const filterIcon = 'assets/svgs/filter.svg';
  static const onboardingTrend = 'assets/svgs/onbording1.svg';
  static const onboardingCheckout = 'assets/svgs/onbording2.svg';
  static const onboardingDelivery = 'assets/svgs/onbording3.svg';
}

class StoreContact {
  const StoreContact._();

  // International format without + or spaces, for example: 201001234567.
  // Leave empty to open WhatsApp with the order text and let the user choose a chat.
  static const whatsAppBusinessPhone = '201019752994';
  static const supportPhone = whatsAppBusinessPhone;
  static const displaySupportPhone = '+20 101 975 2994';
  static const supportEmail = 'ahmedabdelrahime0@gmail.com';

  static String supportWhatsAppMessage() {
    return 'Hello ${StoreConfig.brandName} team, I need help with my order.';
  }

  static String supportEmailSubject() {
    return '${StoreConfig.brandName} order support';
  }
}

class StoreLocation {
  const StoreLocation._();

  static const countryName = StoreConfig.countryName;
  static const defaultLatitude = 30.0444;
  static const defaultLongitude = 31.2357;
  static const sampleAddress = 'Cairo, Egypt';
}

class StorePayment {
  const StorePayment._();

  static const cashOnDeliveryLabel = 'Cash on Delivery';
  static const cashOnDeliveryDescription =
      'Pay in cash when your order arrives.';
  static const defaultPaymentNote = 'Payment: Cash on Delivery';
}

class StoreOrderMessages {
  const StoreOrderMessages._();

  static const whatsAppOrderNote = 'WhatsApp order';
  static const availabilityConfirmationNote =
      'Please confirm availability and delivery time.';
  static const orderIntro = 'I want to confirm this order.';

  static String orderGreeting() {
    return 'Hello ${StoreConfig.brandName} team,';
  }
}

class StoreOrderNoteLabels {
  const StoreOrderNoteLabels._();

  static const payment = 'Payment';
  static const phone = 'Phone';
  static const coupon = 'Coupon';
}

class StoreColors {
  const StoreColors._();

  static const appBackground = Color(0xFFF5F5F5);
  static const brandPrimary = Color(0xFFF83758);
  static const neutralMuted = Color(0xFFA8A8A9);
  static const textPrimary = Color.fromARGB(255, 10, 14, 22);
  static const textSecondary = Color(0xFF676767);
  static const success = Color(0xFF1E8E5A);
  static const warning = Color(0xFFB7791F);
}

class StoreSizes {
  const StoreSizes._();

  static const clothing = <String>['XS', 'S', 'M', 'L', 'XL', '2XL', '3XL'];

  static const shoes = <String>[
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
  ];

  static const fallbackFashionSizes = <String>['S', 'M', 'L', 'XL'];

  static String normalize(Object? value) => value?.toString().trim() ?? '';

  static List<String> normalizeList(Iterable<dynamic>? values) {
    final seen = <String>{};
    final sizes = <String>[];

    for (final raw in values ?? const <dynamic>[]) {
      final normalized = normalize(raw);
      if (normalized.isEmpty || !seen.add(normalized)) {
        continue;
      }
      sizes.add(normalized);
    }

    return sizes;
  }

  static String label(String size) => size;

  static List<String> defaultsForProduct({
    String? name,
    String? title,
    String? category,
  }) {
    final source = [
      name,
      title,
      category,
    ].whereType<String>().join(' ').toLowerCase();

    final looksLikeShoes =
        source.contains('shoe') ||
        source.contains('sneaker') ||
        source.contains('boot') ||
        source.contains('sandal') ||
        source.contains('حذاء') ||
        source.contains('جزمة') ||
        source.contains('كوتشي');

    return looksLikeShoes ? shoes : clothing;
  }
}

class AppPrice {
  const AppPrice._();

  static String amount(num value) {
    final asDouble = value.toDouble();
    if (asDouble == asDouble.roundToDouble()) {
      return asDouble.toStringAsFixed(0);
    }

    return asDouble.toStringAsFixed(2);
  }

  static String format(num value, {String? currencyCode}) {
    final code = (currencyCode == null || currencyCode.trim().isEmpty)
        ? StoreConfig.currencyCode
        : currencyCode.trim();

    return '${amount(value)} $code';
  }

  static String discount(num value, {String? currencyCode}) {
    return '- ${format(value, currencyCode: currencyCode)}';
  }
}
