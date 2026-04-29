import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hungry/pages/auth/screens/rest_password.dart';
import 'package:hungry/pages/spalsh_screen.dart';
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

  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    if (data.event == AuthChangeEvent.passwordRecovery) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (_) => const ResetPassword()),
      );
    }
  });

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(splashColor: Colors.transparent),
      debugShowCheckedModeBanner: false,
      home: const SpalshScreen(),
    );
  }
}
