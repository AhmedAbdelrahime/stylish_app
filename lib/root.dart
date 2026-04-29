import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hungry/core/constants/app_colors.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          boxShadow: [
            // ignore: deprecated_member_use
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
          ],
        ),
        child: GNav(
          gap: 8,
          activeColor: Colors.white,
          iconSize: 24,
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 600),
          // ignore: deprecated_member_use
          tabBackgroundColor: AppColors.redColor.withOpacity(.8),
          color: Colors.grey,
          selectedIndex: currentpage,
          onTabChange: (value) {
            setState(() {
              currentpage = value;
            });
          },

          tabs: [
            const GButton(icon: Icons.home_outlined, text: 'Home'),
            GButton(
              icon: Icons.shopping_cart_outlined,
              text: 'Cart',
              leading: ValueListenableBuilder<int>(
                valueListenable: CartService.itemCountNotifier,
                builder: (context, count, _) {
                  return _CartTabIcon(count: count, isActive: currentpage == 1);
                },
              ),
            ),
            const GButton(icon: Icons.search, text: 'Search'),
            const GButton(icon: Icons.settings_outlined, text: 'Settings'),
          ],
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
          Icons.shopping_cart_outlined,
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
