import 'package:hungry/core/config/store_config.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String description;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnboardingModel> onboarding = [
  OnboardingModel(
    image: StoreAssets.onboardingTrend,
    title: 'Discover New Trends',
    description:
        'Browse curated fashion, accessories, and everyday essentials picked to match your style.',
  ),
  OnboardingModel(
    image: StoreAssets.onboardingCheckout,
    title: 'Secure Checkout',
    description:
        'Pay safely with a smooth checkout experience designed to make every order quick and easy.',
  ),
  OnboardingModel(
    image: StoreAssets.onboardingDelivery,
    title: 'Fast Delivery',
    description:
        'Track your package and get your favorite items delivered right to your door without the wait.',
  ),
];
