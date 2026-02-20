import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/cart/view/cart_page.dart';
import 'package:hungry/pages/home/view/home_page.dart';
import 'package:hungry/pages/search/view/search_page.dart';
import 'package:hungry/pages/settings/view/settings_page.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late PageController pageController = PageController();
  late List<Widget> screens = [
    HomePage(),
    CartPage(),
    SearchPage(),
    SettingsPage(),
  ];

  int currentpage = 0;
  // bool isGuest = false;
  // AuthRepo authRepo = AuthRepo();

  bool isloadinglogout = false;

  // UserModel? userModel;
  // Future<void> getProfileData() async {
  //   try {
  //     final user = await authRepo.getProfileData();
  //     setState(() {
  //       userModel = user;
  //     });
  //   } catch (e) {
  //     String errorMsg = 'Error in profile';
  //     ScaffoldMessenger.of(context).showSnackBar(customSnakBar(errorMsg));
  //   }
  // }

  // Future<void> autologin() async {
  //   try {
  //     final user = await authRepo.autoLogin();
  //     setState(() {
  //       isGuest = authRepo.isGuest;
  //     });
  //     if (user != null) {
  //       setState(() {
  //         userModel = user;
  //       });
  //     }
  //   } catch (e) {
  //     String errorMsg = 'Error in profile';
  //     // ScaffoldMessenger.of(context).showSnackBar(customSnakBar(errorMsg));
  //   }
  // }

  // Future<void> logout() async {
  //   try {
  //     setState(() => isloadinglogout = true);

  //     await authRepo.logout();
  //     if (!mounted) return;
  //     setState(() => isloadinglogout = false);
  //     await Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) {
  //           return LoginView();
  //         },
  //       ),
  //     );
  //   } catch (e) {
  //     if (!mounted) return;

  //     setState(() => isloadinglogout = false);

  //     String errMsg = 'Failed to logout';
  //     if (e is ApiError) errMsg = e.message;

  //     ScaffoldMessenger.of(context).showSnackBar(customSnakBar(errMsg));
  //   }
  // }

  @override
  // void initState() {
  //   // autologin();
  //   // getProfileData();
  //   screens = [HomePage(), CartPage(), SearchPage(), SettingsPage()];
  //   pageController = PageController(initialPage: currentpage);
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: screens[currentpage],
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
            const GButton(icon: Icons.shopping_cart_outlined, text: 'Cart'),
            const GButton(icon: Icons.search, text: 'Search'),
            const GButton(icon: Icons.settings_outlined, text: 'Settings'),
          ],
        ),
      ),
    );
  }
}
