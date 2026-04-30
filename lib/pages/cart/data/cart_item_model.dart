import 'package:hungry/core/config/store_config.dart';
import 'package:hungry/pages/home/models/product_model.dart';

class CartItemModel {
  const CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.productTitle,
    required this.imagePath,
    required this.price,
    required this.quantity,
    required this.stockQuantity,
    this.originalPrice,
    this.color,
    this.size,
    this.rating = 0,
  });

  final String id;
  final String productId;
  final String name;
  final String productTitle;
  final String imagePath;
  final double price;
  final int quantity;
  final int stockQuantity;
  final double? originalPrice;
  final String? color;
  final String? size;
  final double rating;

  factory CartItemModel.fromProduct({
    required ProductModel product,
    required int quantity,
    String? selectedSize,
    String? color,
  }) {
    return CartItemModel(
      id: storageId(product.id, selectedSize),
      productId: product.id,
      name: product.name,
      productTitle: product.title,
      imagePath: product.primaryImage,
      price: product.effectivePrice,
      quantity: quantity,
      stockQuantity: product.stockQuantity,
      originalPrice: product.hasSale ? product.price : null,
      color: color,
      size: selectedSize,
      rating: product.rating,
    );
  }

  static String storageId(String productId, String? size) {
    return '$productId::${size ?? 'default'}';
  }

  bool get hasDiscount =>
      originalPrice != null && originalPrice! > 0 && originalPrice! > price;

  bool get isInStock => !StoreConfig.enforceStockQuantity || stockQuantity > 0;

  bool get isLowStock =>
      StoreConfig.enforceStockQuantity && isInStock && stockQuantity <= 3;

  double get lineTotal => price * quantity;

  int get discountPercentage {
    if (!hasDiscount) return 0;

    final discount = ((originalPrice! - price) / originalPrice!) * 100;
    return discount.round();
  }
}
