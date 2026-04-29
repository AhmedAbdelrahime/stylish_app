import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
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
        ),
      ],
    );
  }
}

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
