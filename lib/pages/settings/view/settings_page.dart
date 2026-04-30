import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/pages/auth/widgets/app_snackbar.dart';
import 'package:hungry/pages/orders/view/orders_page.dart';
import 'package:hungry/pages/settings/data/location_address_service.dart';
import 'package:hungry/pages/settings/data/profile_service.dart';
import 'package:hungry/pages/settings/data/user_model.dart';
import 'package:hungry/pages/settings/view/map_address_picker_page.dart';
import 'package:hungry/pages/settings/widgets/app_bar_section.dart';
import 'package:hungry/pages/settings/widgets/contact_us_section.dart';
import 'package:hungry/pages/settings/widgets/custom_bottom_sheet.dart';
import 'package:hungry/pages/settings/widgets/image_section_widget.dart';
import 'package:hungry/pages/settings/widgets/language_section.dart';
import 'package:hungry/pages/settings/widgets/setting_form.dart';
import 'package:hungry/pages/settings/widgets/smart_refresh_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinCodeontroller = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final RefreshController _refreshcontroller = RefreshController(
    initialRefresh: false,
  );
  final ProfileService _profileService = ProfileService();
  final LocationAddressService _locationAddressService =
      LocationAddressService();
  bool isloading = false;
  bool isloadingData = false;
  bool isDelete = false;
  bool isDetectingLocation = false;
  UserModel? _user;
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    pinCodeontroller.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    super.dispose();
  }

  Future<void> loadUserData() async {
    setState(() => isloadingData = true);
    final profile = await _profileService.getProfile();
    if (!mounted) return;

    _user = profile;
    if (_user != null) {
      nameController.text = _user!.name ?? '';
      emailController.text = _user!.email;
      phoneController.text = _user!.phone ?? '';
      addressController.text = _user!.address ?? '';
      cityController.text = _user!.city ?? '';
      stateController.text = _user!.state ?? '';
      countryController.text = _user!.country ?? '';
      pinCodeontroller.text = _user!.pincode ?? '';
    }
    setState(() => isloadingData = false);
  }

  Future<void> updateProfile() async {
    if (_user == null) return;
    setState(() => isloading = true);
    final updatedUser = UserModel(
      userId: _user!.userId,
      email: _user!.email,
      name: nameController.text,
      phone: phoneController.text,
      address: addressController.text,
      city: cityController.text,
      state: stateController.text,
      country: countryController.text,
      pincode: pinCodeontroller.text,
      image: _user!.image,
    );
    await _profileService.updateProfile(updatedUser);
    if (!mounted) return;
    _user = updatedUser;
    setState(() => isloading = false);
    AppSnackBar.show(
      context: context,
      text: 'Profile updated successfully.',
      backgroundColor: Colors.green,
    );
  }

  Future<void> useCurrentLocation() async {
    setState(() => isDetectingLocation = true);

    try {
      final detectedAddress = await _locationAddressService
          .detectCurrentAddress();
      if (!mounted) return;

      applyDetectedAddress(detectedAddress);
      AppSnackBar.show(
        context: context,
        text: 'Address detected successfully.',
        backgroundColor: Colors.green,
        icon: Icons.check_circle_outline,
      );
    } on LocationAddressException catch (error) {
      if (!mounted) return;
      AppSnackBar.show(
        context: context,
        text: error.message,
        backgroundColor: AppColors.redColor,
      );
    } catch (_) {
      if (!mounted) return;
      AppSnackBar.show(
        context: context,
        text: 'Could not detect your address.',
        backgroundColor: AppColors.redColor,
      );
    } finally {
      if (mounted) setState(() => isDetectingLocation = false);
    }
  }

  Future<void> pickAddressOnMap() async {
    final detectedAddress = await Navigator.push<DetectedAddress>(
      context,
      MaterialPageRoute(builder: (_) => const MapAddressPickerPage()),
    );

    if (!mounted || detectedAddress == null) return;

    applyDetectedAddress(detectedAddress);
    AppSnackBar.show(
      context: context,
      text: 'Address selected from map.',
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }

  void applyDetectedAddress(DetectedAddress detectedAddress) {
    final addressText = detectedAddress.address.isNotEmpty
        ? detectedAddress.address
        : '${detectedAddress.latitude.toStringAsFixed(6)}, '
              '${detectedAddress.longitude.toStringAsFixed(6)}';

    setState(() {
      addressController.text = addressText;

      if (detectedAddress.city.isNotEmpty) {
        cityController.text = detectedAddress.city;
      }
      if (detectedAddress.state.isNotEmpty) {
        stateController.text = detectedAddress.state;
      }
      if (detectedAddress.country.isNotEmpty) {
        countryController.text = detectedAddress.country;
      }
      if (detectedAddress.pincode.isNotEmpty) {
        pinCodeontroller.text = detectedAddress.pincode;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBarSection(showBackButton: widget.showBackButton),
        backgroundColor: AppColors.primaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SmartRefreshWidget(
                  controller: _refreshcontroller,
                  onRefresh: () async {
                    await loadUserData();
                    _refreshcontroller.refreshCompleted();
                  },
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Skeletonizer(
                      enabled: isloadingData,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImageSectionWidget(),
                          const SizedBox(height: 16),
                          const LanguageSection(),
                          const SizedBox(height: 16),

                          SettingForm(
                            nameController: nameController,
                            emailController: emailController,
                            phoneController: phoneController,
                            pinCodeontroller: pinCodeontroller,
                            addressController: addressController,
                            cityController: cityController,
                            stateController: stateController,
                            countryController: countryController,
                            isDetectingLocation: isDetectingLocation,
                            onUseCurrentLocation: useCurrentLocation,
                            onPickOnMap: pickAddressOnMap,
                          ),
                          const SizedBox(height: 16),
                          _OrdersShortcut(),
                          const SizedBox(height: 16),
                          const ContactUsSection(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomSheet: CustomBottomsheet(
          isloadingUpdate: isloading,
          upadateProfileData: updateProfile,
        ),
      ),
    );
  }
}

class _OrdersShortcut extends StatelessWidget {
  const _OrdersShortcut();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OrdersPage()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: AppColors.redColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.redColor,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Orders',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Track delivery status and payment details',
                      style: TextStyle(
                        color: AppColors.hintColor,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.hintColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
