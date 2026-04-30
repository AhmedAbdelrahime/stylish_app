import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/l10n/app_localizations.dart';
import 'package:hungry/pages/settings/widgets/change_password_sheet_widget.dart';
import 'package:hungry/pages/settings/widgets/text_field_custom.dart';
import 'package:hungry/shared/custom_text.dart';

class SettingForm extends StatelessWidget {
  const SettingForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.pinCodeontroller,
    required this.addressController,
    required this.cityController,
    required this.stateController,
    required this.countryController,
    required this.onUseCurrentLocation,
    required this.onPickOnMap,
    required this.isDetectingLocation,
  });
  final TextEditingController nameController;
  final TextEditingController pinCodeontroller;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController countryController;
  final VoidCallback onUseCurrentLocation;
  final VoidCallback onPickOnMap;
  final bool isDetectingLocation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(25),
        CustomText(text: 'Personal Details', size: 18, weight: FontWeight.w600),
        SettingTextField(controller: nameController, labelText: 'UserName'),
        SettingTextField(
          controller: emailController,
          labelText: 'Email',
          enabled: false,
        ),
        SettingTextField(
          controller: phoneController,
          labelText: 'Contact Number',
          keyboardType: TextInputType.phone,
        ),
        Gap(10),
        ChangePasswordSheetWidget(),
        Gap(10),

        Divider(),
        CustomText(
          text: 'Business Address Details',
          size: 18,
          weight: FontWeight.w600,
        ),
        const Gap(12),
        _LocationActionsCard(
          isDetectingLocation: isDetectingLocation,
          onUseCurrentLocation: onUseCurrentLocation,
          onPickOnMap: onPickOnMap,
        ),
        const Gap(12),

        SettingTextField(controller: pinCodeontroller, labelText: 'Pincode'),
        SettingTextField(controller: addressController, labelText: ' Address'),
        SettingTextField(controller: cityController, labelText: ' City'),
        SettingTextField(controller: stateController, labelText: ' State'),
        SettingTextField(controller: countryController, labelText: 'Country'),
        Divider(),
      ],
    );
  }
}

class _LocationActionsCard extends StatelessWidget {
  const _LocationActionsCard({
    required this.isDetectingLocation,
    required this.onUseCurrentLocation,
    required this.onPickOnMap,
  });

  final bool isDetectingLocation;
  final VoidCallback onUseCurrentLocation;
  final VoidCallback onPickOnMap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.near_me_outlined, color: AppColors.redColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.tr('Address location'),
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              context.tr(
                'Accurate delivery details for faster order handling.',
              ),
              style: const TextStyle(
                color: AppColors.hintColor,
                fontSize: 12,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isDetectingLocation
                        ? null
                        : onUseCurrentLocation,
                    icon: isDetectingLocation
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.redColor,
                            ),
                          )
                        : const Icon(Icons.my_location_rounded),
                    label: Text(
                      context.tr(isDetectingLocation ? 'Detecting' : 'Use GPS'),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.redColor,
                      minimumSize: const Size(0, 44),
                      side: const BorderSide(color: AppColors.redColor),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isDetectingLocation ? null : onPickOnMap,
                    icon: const Icon(Icons.map_outlined),
                    label: Text(context.tr('Pick Map')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 44),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
