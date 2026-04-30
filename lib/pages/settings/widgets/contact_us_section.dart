import 'package:flutter/material.dart';
import 'package:hungry/core/config/store_config.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/l10n/app_localizations.dart';
import 'package:hungry/pages/auth/widgets/app_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsSection extends StatelessWidget {
  const ContactUsSection({super.key});

  Future<void> _openWhatsApp(BuildContext context) async {
    final phone = _digitsOnly(StoreContact.whatsAppBusinessPhone);
    final message = StoreContact.supportWhatsAppMessage();

    final appUri = Uri(
      scheme: 'whatsapp',
      host: 'send',
      queryParameters: {if (phone.isNotEmpty) 'phone': phone, 'text': message},
    );

    if (await canLaunchUrl(appUri)) {
      final opened = await launchUrl(
        appUri,
        mode: LaunchMode.externalApplication,
      );
      if (opened) return;
    }

    final webUri = Uri.https('wa.me', phone.isEmpty ? '/' : '/$phone', {
      'text': message,
    });

    if (await launchUrl(webUri, mode: LaunchMode.externalApplication)) {
      return;
    }

    if (!context.mounted) return;
    AppSnackBar.show(
      context: context,
      text: 'Could not open WhatsApp.',
      backgroundColor: AppColors.redColor,
    );
  }

  Future<void> _callSupport(BuildContext context) async {
    final phone = _digitsOnly(StoreContact.supportPhone);
    if (phone.isEmpty) return;

    final uri = Uri(scheme: 'tel', path: phone);
    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      return;
    }

    if (!context.mounted) return;
    AppSnackBar.show(
      context: context,
      text: 'Could not open phone dialer.',
      backgroundColor: AppColors.redColor,
    );
  }

  Future<void> _emailSupport(BuildContext context) async {
    final email = StoreContact.supportEmail.trim();
    if (email.isEmpty) return;

    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': StoreContact.supportEmailSubject()},
    );

    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      return;
    }

    if (!context.mounted) return;
    AppSnackBar.show(
      context: context,
      text: 'Could not open email app.',
      backgroundColor: AppColors.redColor,
    );
  }

  String _digitsOnly(String value) => value.replaceAll(RegExp(r'[^0-9]'), '');

  @override
  Widget build(BuildContext context) {
    final hasPhone = _digitsOnly(StoreContact.supportPhone).isNotEmpty;
    final hasEmail = StoreContact.supportEmail.trim().isNotEmpty;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.support_agent_outlined,
                  color: AppColors.redColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.tr('Contact Us'),
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              context.tr(
                'Need help with an order, delivery, or product? Reach us directly.',
              ),
              style: const TextStyle(
                color: AppColors.hintColor,
                fontSize: 12,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _ContactActionButton(
                    icon: Icons.chat_bubble_outline,
                    label: 'WhatsApp',
                    color: const Color(0xFF128C7E),
                    onTap: () => _openWhatsApp(context),
                  ),
                ),
                if (hasPhone) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ContactActionButton(
                      icon: Icons.call_outlined,
                      label: 'Call',
                      color: AppColors.redColor,
                      onTap: () => _callSupport(context),
                    ),
                  ),
                ],
                if (hasEmail) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ContactActionButton(
                      icon: Icons.mail_outline,
                      label: 'Email',
                      color: AppColors.blackColor,
                      onTap: () => _emailSupport(context),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactActionButton extends StatelessWidget {
  const _ContactActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(context.tr(label), overflow: TextOverflow.ellipsis),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
