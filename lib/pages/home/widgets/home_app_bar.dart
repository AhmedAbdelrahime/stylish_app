import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hungry/core/api/supabase_error_mapper.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/auth/data/auth_service.dart';
import 'package:hungry/pages/cart/view/cart_page.dart';
import 'package:hungry/pages/home/logic/favorites/favorites_controller.dart';
import 'package:hungry/pages/home/view/wishlist_page.dart';
import 'package:hungry/pages/settings/view/settings_page.dart';
import 'package:hungry/pages/settings/widgets/logout_dialog.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, this.profileimageUrl, this.showBackButton});

  final String? profileimageUrl;
  final bool? showBackButton;
  static final FavoritesController _favorites = FavoritesController.instance;

  Future<void> _openQuickActions(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Open the sections people usually need most.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.hintColor,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                _MenuTile(
                  icon: Icons.favorite_border_rounded,
                  title: 'Wishlist',
                  subtitle: 'See your saved items',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WishlistPage(),
                      ),
                    );
                  },
                ),
                _MenuTile(
                  icon: Icons.shopping_cart_outlined,
                  title: 'Cart',
                  subtitle: 'Review your bag items',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    );
                  },
                ),
                _MenuTile(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  subtitle: 'Manage profile and address',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
                _MenuTile(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  subtitle: 'Sign out of this account',
                  isDestructive: true,
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (_) => const LogoutDialog(),
                    );

                    if (shouldLogout != true || !context.mounted) return;

                    try {
                      await AuthService().signOut();
                    } catch (error) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(SupabaseErrorMapper.map(error))),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowBackButton =
        showBackButton ?? Navigator.of(context).canPop();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          _ActionBox(
            onTap: shouldShowBackButton
                ? () => Navigator.of(context).pop()
                : () => _openQuickActions(context),
            child: shouldShowBackButton
                ? const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.blackColor,
                    size: 20,
                  )
                : SvgPicture.asset('assets/svgs/menu.svg', height: 22),
          ),
          Expanded(
            child: Center(
              child: SvgPicture.asset('assets/logo/logo.svg', height: 35),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _favorites,
                builder: (context, _) {
                  return _ActionBox(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WishlistPage(),
                        ),
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.favorite_border_rounded,
                          color: AppColors.blackColor,
                          size: 22,
                        ),
                        if (_favorites.count > 0)
                          Positioned(
                            right: -6,
                            top: -6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.redColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                _favorites.count > 9
                                    ? '9+'
                                    : _favorites.count.toString(),
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              _ActionBox(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: profileimageUrl != null
                      ? Image.network(
                          profileimageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/profile.png',
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/images/profile.png',
                          fit: BoxFit.cover,
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

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final accentColor = isDestructive
        ? AppColors.redColor
        : AppColors.blackColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isDestructive
            ? AppColors.redColor.withValues(alpha: 0.08)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: accentColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.hintColor,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: accentColor.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionBox extends StatelessWidget {
  const _ActionBox({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: 48,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(child: child),
      ),
    );
  }
}
