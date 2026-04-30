import 'package:hungry/core/config/store_config.dart';

class ProductModel {
  final String id;
  final String name;
  final double price;
  final double? salePrice;
  final String title;
  final String description;
  final double rating;
  final String? mainImageUrl;
  final List<String> imageUrls;
  final List<String> sizes;
  final String? categoryId;
  final int stockQuantity;
  final int lowStockThreshold;
  final String status;
  final bool featured;
  final String? sku;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.salePrice,
    required this.title,
    required this.description,
    required this.rating,
    required this.imageUrls,
    this.mainImageUrl,
    this.sizes = const [],
    this.categoryId,
    this.stockQuantity = 0,
    this.lowStockThreshold = 5,
    this.status = 'active',
    this.featured = false,
    this.sku,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final imageUrls =
        (json['image_urls'] as List<dynamic>?)
            ?.map((item) => item.toString())
            .toList() ??
        [];
    final sizes = StoreSizes.normalizeList(json['sizes'] as List<dynamic>?);

    return ProductModel(
      id: json['id'].toString(),
      name: (json['name'] ?? '') as String,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      salePrice: (json['sale_price'] as num?)?.toDouble(),
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      mainImageUrl: json['main_image_url'] as String?,
      imageUrls: imageUrls,
      sizes: sizes,
      categoryId: json['category_id'] as String?,
      stockQuantity: (json['stock_quantity'] as num?)?.toInt() ?? 0,
      lowStockThreshold: (json['low_stock_threshold'] as num?)?.toInt() ?? 5,
      status: (json['status'] ?? 'active') as String,
      featured: json['featured'] as bool? ?? false,
      sku: json['sku'] as String?,
    );
  }

  String get primaryImage => mainImageUrl?.isNotEmpty == true
      ? mainImageUrl!
      : imageUrls.isNotEmpty
      ? imageUrls.first
      : '';

  bool get hasSale => salePrice != null && salePrice! > 0 && salePrice! < price;

  double get effectivePrice => hasSale ? salePrice! : price;

  bool get isLowStock =>
      StoreConfig.enforceStockQuantity &&
      stockQuantity > 0 &&
      stockQuantity <= lowStockThreshold;

  bool get isInStock => !StoreConfig.enforceStockQuantity || stockQuantity > 0;

  List<String> get availableSizes {
    if (sizes.isNotEmpty) {
      return sizes;
    }

    if (!StoreConfig.useFallbackSizesWhenProductSizesMissing) {
      return const [];
    }

    return StoreSizes.defaultsForProduct(name: name, title: title);
  }
}
