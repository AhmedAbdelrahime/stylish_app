import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/auth/screens/login_screen.dart';
import 'package:hungry/pages/onboardings/models/onboarding_model.dart';
import 'package:hungry/pages/onboardings/services/onbordingserv.dart';
import 'package:hungry/pages/onboardings/widgets/build_page.dart';
import 'package:hungry/pages/onboardings/widgets/onbarding_footer.dart';
import 'package:hungry/pages/onboardings/widgets/onbarding_header.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool islast = false;
  bool isFrist = true;
  int cout = 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _skipOnboarding() async {
    await OnboardingService.setSeenOnboarding();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    // final width = screenSize.width;
    // final hight = screenSize.height;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        child: Column(
          children: [
            OnbardingHeader(count: cout, onSkip: _skipOnboarding),

            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboarding.length,
                onPageChanged: (value) {
                  setState(() {
                    islast = value == onboarding.length - 1;
                    isFrist = value == 0;
                    cout = value + 1;
                  });
                },
                itemBuilder: (context, index) =>
                    BuildPage(onbordings: onboarding[index]),
              ),
            ),
            OnbardingFooter(
              isFrist: isFrist,
              islast: islast,
              controller: _controller,
            ),
          ],
        ),
      ),
    );
  }
}
