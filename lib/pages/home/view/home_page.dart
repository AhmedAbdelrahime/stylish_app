import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/l10n/app_localizations.dart';
import 'package:hungry/pages/home/data/category_service.dart';
import 'package:hungry/pages/home/data/offer_service.dart';
import 'package:hungry/pages/home/data/product_service.dart';
import 'package:hungry/pages/home/logic/category/cubit/category_cubit.dart';
import 'package:hungry/pages/home/logic/category/cubit/category_state.dart';
import 'package:hungry/pages/home/logic/offer/cubit/offer_cubit.dart';
import 'package:hungry/pages/home/logic/product/cubit/product_cubit.dart';
import 'package:hungry/pages/home/logic/product/cubit/product_state.dart';
import 'package:hungry/pages/home/widgets/cat_section.dart';
import 'package:hungry/pages/home/widgets/home_app_bar.dart';
import 'package:hungry/pages/home/widgets/offers_section.dart';
import 'package:hungry/pages/home/widgets/products_section.dart';
import 'package:hungry/pages/settings/data/profile_service.dart';
import 'package:hungry/pages/settings/data/user_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProfileService _profileService = ProfileService();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = await _profileService.getProfile();
    if (!mounted) return;

    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CategoryCubit(CategoryService())..loadCategories(),
        ),
        BlocProvider(create: (_) => OfferCubit(OfferService())..loadOffers()),
        BlocProvider(
          create: (_) => ProductCubit(ProductService())..loadProducts(),
        ),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: SafeArea(
            child: Skeletonizer(
              enabled: false,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 28),
                children: [
                  HomeAppBar(profileimageUrl: _user?.image),
                  const Gap(18),
                  const _HomeSectionHeader(
                    title: 'Shop By Category',
                    subtitle:
                        'Start with a department and explore curated products.',
                  ),
                  const Gap(6),
                  const CatSection(),
                  const Gap(20),
                  const OffersSection(),
                  const Gap(28),
                  const ProudectsSection(
                    title: 'Trending Now',
                    subtitle: 'Popular picks customers are opening first.',
                    maxItems: 6,
                    mode: ProductSectionMode.highestRated,
                  ),
                  const Gap(28),
                  const _CategoryProductSections(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeSectionHeader extends StatelessWidget {
  const _HomeSectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr(title),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
          ),
          const Gap(4),
          Text(
            context.tr(subtitle),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.hintColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryProductSections extends StatelessWidget {
  const _CategoryProductSections();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, categoryState) {
        if (categoryState is! CategoryLoaded) {
          return const SizedBox.shrink();
        }

        return BlocBuilder<ProductCubit, ProductState>(
          builder: (context, productState) {
            if (productState is! ProductLoaded) {
              return const SizedBox.shrink();
            }

            final sections = categoryState.categories
                .map((category) {
                  final categoryProducts = productState.products
                      .where((product) => product.categoryId == category.id)
                      .toList();
                  return (category.name, categoryProducts);
                })
                .where((entry) => entry.$2.isNotEmpty)
                .toList();

            if (sections.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                for (final section in sections) ...[
                  ProudectsSection(
                    title: section.$1,
                    subtitle: context.tr(
                      'More products selected from this category.',
                    ),
                    products: section.$2,
                    maxItems: 8,
                    mode: ProductSectionMode.highestRated,
                  ),
                  const Gap(28),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
