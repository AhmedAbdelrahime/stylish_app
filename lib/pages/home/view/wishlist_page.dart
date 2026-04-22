import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/home/data/product_service.dart';
import 'package:hungry/pages/home/logic/favorites/favorites_controller.dart';
import 'package:hungry/pages/home/logic/product/cubit/product_cubit.dart';
import 'package:hungry/pages/home/logic/product/cubit/product_state.dart';
import 'package:hungry/pages/home/widgets/card_item.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  static final FavoritesController _favorites = FavoritesController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleSpacing: 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wishlist',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),
            Text(
              'Your saved favorites in one place.',
              style: TextStyle(fontSize: 12, color: AppColors.hintColor),
            ),
          ],
        ),
      ),
      body: AnimatedBuilder(
        animation: _favorites,
        builder: (context, _) {
          final favoriteIds = _favorites.favoriteProductIds;

          if (_favorites.isLoading && favoriteIds.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (favoriteIds.isEmpty) {
            return const _EmptyWishlistState();
          }

          return BlocProvider(
            create: (context) => ProductCubit(ProductService())..loadProducts(),
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProductError) {
                  return Center(
                    child: Text(state.message, textAlign: TextAlign.center),
                  );
                }

                if (state is ProductLoaded) {
                  final favoriteProducts = state.products
                      .where((product) => favoriteIds.contains(product.id))
                      .toList();

                  if (favoriteProducts.isEmpty) {
                    return const _EmptyWishlistState();
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    itemCount: favoriteProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.58,
                        ),
                    itemBuilder: (context, index) => CardItem(
                      product: favoriteProducts[index],
                      relatedProducts: favoriteProducts,
                      margin: EdgeInsets.zero,
                    ),
                  );
                }

                return const Center(child: Text('Loading wishlist...'));
              },
            ),
          );
        },
      ),
    );
  }
}

class _EmptyWishlistState extends StatelessWidget {
  const _EmptyWishlistState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.favorite_border_rounded,
              size: 56,
              color: AppColors.grayColor,
            ),
            SizedBox(height: 14),
            Text(
              'Your wishlist is empty',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the heart on any product card to save it here for later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.hintColor,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
