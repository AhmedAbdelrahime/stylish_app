import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:hungry/core/theme/app_theme.dart';
import 'package:hungry/l10n/app_localizations.dart';
import 'package:hungry/l10n/locale_controller.dart';
import 'package:hungry/pages/auth/screens/rest_password.dart';
import 'package:hungry/pages/spalsh_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://apijlhhescaneunlxcjp.supabase.co',
    anonKey: 'sb_publishable_h4ZcJoSQvSErw1N7_KHUcg_WreRR2Za',
  );
  //apijlhhescaneunlxcjp
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final localeController = LocaleController();
  await localeController.load();

  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    if (data.event == AuthChangeEvent.passwordRecovery) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (_) => const ResetPassword()),
      );
    }
  });

  runApp(
    ChangeNotifierProvider.value(value: localeController, child: const MyApp()),
  );
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleController>(
      builder: (context, localeController, _) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          locale: localeController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.light,
          debugShowCheckedModeBanner: false,
          home: const SpalshScreen(),
        );
      },
    );
  }
}
