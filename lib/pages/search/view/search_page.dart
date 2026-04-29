import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/home/data/product_service.dart';
import 'package:hungry/pages/home/logic/product/cubit/product_cubit.dart';
import 'package:hungry/pages/home/logic/product/cubit/product_state.dart';
import 'package:hungry/pages/home/models/product_model.dart';
import 'package:hungry/pages/home/widgets/card_item.dart';
import 'package:hungry/pages/home/widgets/home_app_bar.dart';
import 'package:hungry/pages/home/widgets/search_text_field.dart';

enum _SearchSortOption {
  featured,
  priceLowToHigh,
  priceHighToLow,
  topRated,
  name,
}

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    this.initialCategoryId,
    this.initialCategoryName,
  });

  final String? initialCategoryId;
  final String? initialCategoryName;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  _SearchSortOption _sortOption = _SearchSortOption.featured;
  double _minRating = 0;
  bool _underFifty = false;
  bool _topRatedOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductModel> _applySearchSortAndFilter(List<ProductModel> products) {
    final query = _searchController.text.trim().toLowerCase();

    final filteredProducts = products.where((product) {
      final matchesCategory =
          widget.initialCategoryId == null ||
          product.categoryId == widget.initialCategoryId;

      final matchesQuery =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.title.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);

      final matchesRating = product.rating >= _minRating;
      final matchesBudget = !_underFifty || product.price <= 50;
      final matchesTopRated = !_topRatedOnly || product.rating >= 4;

      return matchesCategory &&
          matchesQuery &&
          matchesRating &&
          matchesBudget &&
          matchesTopRated;
    }).toList();

    switch (_sortOption) {
      case _SearchSortOption.priceLowToHigh:
        filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case _SearchSortOption.priceHighToLow:
        filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case _SearchSortOption.topRated:
        filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case _SearchSortOption.name:
        filteredProducts.sort((a, b) => a.name.compareTo(b.name));
        break;
      case _SearchSortOption.featured:
        break;
    }

    return filteredProducts;
  }

  String get _sortLabel {
    switch (_sortOption) {
      case _SearchSortOption.featured:
        return 'Featured';
      case _SearchSortOption.priceLowToHigh:
        return 'Price: Low to High';
      case _SearchSortOption.priceHighToLow:
        return 'Price: High to Low';
      case _SearchSortOption.topRated:
        return 'Top Rated';
      case _SearchSortOption.name:
        return 'Name';
    }
  }

  int get _activeFilterCount {
    var count = 0;
    if (widget.initialCategoryId != null) count++;
    if (_minRating > 0) count++;
    if (_underFifty) count++;
    if (_topRatedOnly) count++;
    return count;
  }

  Future<void> _openSortSheet() async {
    final selected = await showModalBottomSheet<_SearchSortOption>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sort Products',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                ..._SearchSortOption.values.map(
                  (option) => _SortOptionTile(
                    title: _sortTitle(option),
                    selected: option == _sortOption,
                    onTap: () => Navigator.pop(context, option),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _sortOption = selected;
      });
    }
  }

  Future<void> _openFilterSheet() async {
    var draftMinRating = _minRating;
    var draftUnderFifty = _underFifty;
    var draftTopRatedOnly = _topRatedOnly;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filter Products',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Minimum Rating',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                    ),
                    Slider(
                      value: draftMinRating,
                      min: 0,
                      max: 5,
                      divisions: 5,
                      activeColor: AppColors.redColor,
                      label: draftMinRating.toStringAsFixed(0),
                      onChanged: (value) {
                        setModalState(() {
                          draftMinRating = value;
                        });
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.redColor,
                      value: draftUnderFifty,
                      title: const Text('Budget friendly: under \u20B950'),
                      onChanged: (value) {
                        setModalState(() {
                          draftUnderFifty = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.redColor,
                      value: draftTopRatedOnly,
                      title: const Text('Only show top rated products (4.0+)'),
                      onChanged: (value) {
                        setModalState(() {
                          draftTopRatedOnly = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _minRating = 0;
                                _underFifty = false;
                                _topRatedOnly = false;
                              });
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.blackColor,
                              side: BorderSide(
                                color: Colors.black.withValues(alpha: 0.08),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _minRating = draftMinRating;
                                _underFifty = draftUnderFifty;
                                _topRatedOnly = draftTopRatedOnly;
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.redColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                            ),
                            child: const Text('Apply'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static String _sortTitle(_SearchSortOption option) {
    switch (option) {
      case _SearchSortOption.featured:
        return 'Featured';
      case _SearchSortOption.priceLowToHigh:
        return 'Price: Low to High';
      case _SearchSortOption.priceHighToLow:
        return 'Price: High to Low';
      case _SearchSortOption.topRated:
        return 'Top Rated';
      case _SearchSortOption.name:
        return 'Name';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SafeArea(
          child: BlocProvider(
            create: (context) => ProductCubit(ProductService())..loadProducts(),
            child: Column(
              children: [
                const HomeAppBar(),
                const SizedBox(height: 14),
                SearchTextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  hintText: 'Search products, styles, and brands',
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Discover Products',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.initialCategoryName == null
                            ? 'Use sorting and filters to narrow the catalog fast.'
                            : 'Browsing ${widget.initialCategoryName} products with quick controls.',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.hintColor,
                          height: 1.4,
                        ),
                      ),
                      if (widget.initialCategoryName != null) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.redColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.category_rounded,
                                size: 16,
                                color: AppColors.redColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.initialCategoryName!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.redColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _ActionChip(
                              label: _sortLabel,
                              icon: Icons.swap_vert_rounded,
                              onTap: _openSortSheet,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ActionChip(
                              label: _activeFilterCount == 0
                                  ? 'Filter'
                                  : 'Filter ($_activeFilterCount)',
                              icon: Icons.tune_rounded,
                              onTap: _openFilterSheet,
                              highlighted: _activeFilterCount > 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is ProductError) {
                        return Center(
                          child: Text(
                            state.message,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      if (state is ProductLoaded) {
                        final visibleProducts = _applySearchSortAndFilter(
                          state.products,
                        );

                        if (visibleProducts.isEmpty) {
                          return const _EmptySearchState();
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          itemCount: visibleProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.58,
                              ),
                          itemBuilder: (context, index) => CardItem(
                            product: visibleProducts[index],
                            relatedProducts: visibleProducts,
                          ),
                        );
                      }

                      return const Center(child: Text('Loading products...'));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
    this.highlighted = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlighted ? AppColors.redColor : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: highlighted ? Colors.white : AppColors.blackColor,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: highlighted ? Colors.white : AppColors.blackColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SortOptionTile extends StatelessWidget {
  const _SortOptionTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected
            ? AppColors.redColor.withValues(alpha: 0.08)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: selected ? AppColors.redColor : AppColors.grayColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.search_off_rounded,
              size: 52,
              color: AppColors.grayColor,
            ),
            SizedBox(height: 14),
            Text(
              'No products match these filters',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8),
            Text(
              'Try a broader search, lower the minimum rating, or clear active filters.',
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
