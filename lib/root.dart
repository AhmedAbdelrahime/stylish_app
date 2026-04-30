import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hungry/core/auth/auth_navigation.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/l10n/app_localizations.dart';
import 'package:hungry/pages/cart/data/cart_service.dart';
import 'package:hungry/pages/cart/view/cart_page.dart';
import 'package:hungry/pages/home/view/home_page.dart';
import 'package:hungry/pages/search/view/search_page.dart';
import 'package:hungry/pages/settings/view/settings_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final PageController pageController = PageController();
  final CartService _cartService = CartService();
  late final StreamSubscription<AuthState> _authSubscription;
  late final List<Widget> screens = const [
    HomePage(),
    CartPage(),
    SearchPage(),
    SettingsPage(),
  ];

  int currentpage = 0;

  bool isloadinglogout = false;

  @override
  void initState() {
    super.initState();
    _loadCartItemCount();
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      data,
    ) {
      if (data.session == null) {
        CartService.itemCountNotifier.value = 0;
        if (currentpage == 3 && mounted) {
          setState(() {
            currentpage = 0;
          });
        }
        return;
      }

      _loadCartItemCount();
    });
  }

  Future<void> _loadCartItemCount() async {
    try {
      await _cartService.syncItemCount();
    } catch (_) {
      CartService.itemCountNotifier.value = 0;
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: screens[currentpage],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              offset: const Offset(0, -8),
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: GNav(
            gap: 8,
            haptic: true,
            curve: Curves.easeOutCubic,
            tabBorderRadius: 18,
            activeColor: Colors.white,
            iconSize: 23,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            duration: const Duration(milliseconds: 350),
            tabBackgroundColor: AppColors.redColor,
            color: AppColors.hintColor,
            selectedIndex: currentpage,
            onTabChange: (value) async {
              if (value == 3 && !AuthNavigation.isSignedIn) {
                final authenticated = await AuthNavigation.requireAuth(
                  context,
                  title: 'Sign in to open Account',
                  message:
                      'Your account keeps your address, orders, and delivery details secure.',
                );
                if (!mounted) return;
                if (!authenticated) return;
              }

              setState(() {
                currentpage = value;
              });
            },

            tabs: [
              GButton(icon: Icons.home_rounded, text: context.tr('Home')),
              GButton(
                icon: Icons.shopping_bag_outlined,
                text: context.tr('Cart'),
                leading: ValueListenableBuilder<int>(
                  valueListenable: CartService.itemCountNotifier,
                  builder: (context, count, _) {
                    return _CartTabIcon(
                      count: count,
                      isActive: currentpage == 1,
                    );
                  },
                ),
              ),
              GButton(icon: Icons.search_rounded, text: context.tr('Search')),
              GButton(
                icon: Icons.person_outline_rounded,
                text: context.tr('Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartTabIcon extends StatelessWidget {
  const _CartTabIcon({required this.count, required this.isActive});

  final int count;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          Icons.shopping_bag_outlined,
          color: isActive ? Colors.white : Colors.grey,
          size: 24,
        ),
        if (count > 0)
          Positioned(
            right: -8,
            top: -7,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : AppColors.redColor,
                borderRadius: BorderRadius.circular(999),
              ),
              constraints: const BoxConstraints(minWidth: 18),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isActive ? AppColors.redColor : Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
