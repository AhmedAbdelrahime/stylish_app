import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
<<<<<<< HEAD
import 'package:hungry/shared/custom_text.dart';

class OtherLogin extends StatelessWidget {
  const OtherLogin({super.key, this.onGoogleTap, this.isGoogleLoading = false});

  final VoidCallback? onGoogleTap;
  final bool isGoogleLoading;

  @override
  Widget build(BuildContext context) {
    final options = [
      const _SocialLoginOption(image: 'assets/icons/apple.png'),
      const _SocialLoginOption(image: 'assets/icons/facebook.png'),
      _SocialLoginOption(
        image: 'assets/icons/google.png',
        onTap: onGoogleTap,
        isLoading: isGoogleLoading,
      ),
    ];

=======
import 'package:hungry/pages/auth/models/loogin_icons.dart';
import 'package:hungry/shared/custom_text.dart';

class OtherLogin extends StatelessWidget {
  const OtherLogin({super.key});

  @override
  Widget build(BuildContext context) {
>>>>>>> 71e363e9e57e6f331681c6680a26430d8356d3c8
    return Column(
      children: [
        Gap(50),
        CustomText(
          text: '- OR Continue with -',
          size: 14,
          weight: FontWeight.w500,
          color: AppColors.hintColor,
        ),
        Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
<<<<<<< HEAD
          children: List.generate(options.length, (index) {
            final option = options[index];
            final isEnabled = option.onTap != null;

            return Opacity(
              opacity: isEnabled ? 1 : 0.45,
              child: GestureDetector(
                onTap: option.onTap,
                child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.redColor,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 255, 240, 240),
                    radius: 20,
                    child: option.isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.redColor,
                            ),
                          )
                        : Image.asset(option.image, width: 30),
                  ),
                ),
              ),
            );
          }),
=======
          children: List.generate(
            icons.length,
            (index) => GestureDetector(
              onTap: icons[index].ontap,

              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppColors.redColor,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 255, 240, 240),
                  radius: 20,
                  child: Image.asset(icons[index].imge, width: 30),
                ),
              ),
            ),
          ),
>>>>>>> 71e363e9e57e6f331681c6680a26430d8356d3c8
        ),
      ],
    );
  }
}
<<<<<<< HEAD

class _SocialLoginOption {
  const _SocialLoginOption({
    required this.image,
    this.onTap,
    this.isLoading = false,
  });

  final String image;
  final VoidCallback? onTap;
  final bool isLoading;
}
=======
>>>>>>> 71e363e9e57e6f331681c6680a26430d8356d3c8
