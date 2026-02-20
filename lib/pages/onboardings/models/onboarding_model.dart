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

  OnboardingModel(image: 'assets/svgs/onbording1.svg', title: 'Choose Products', description: 'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.'),
  OnboardingModel(image: 'assets/svgs/onbording2.svg', title: 'Market Payment', description: 'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.'),
  OnboardingModel(image: 'assets/svgs/onbording3.svg', title: 'Get Order', description: 'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.'),
];