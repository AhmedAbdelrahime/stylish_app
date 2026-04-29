import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hungry/pages/auth/screens/rest_password.dart';
import 'package:hungry/pages/spalsh_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
<<<<<<< HEAD
    url: 'https://apijlhhescaneunlxcjp.supabase.co',
    anonKey: 'sb_publishable_h4ZcJoSQvSErw1N7_KHUcg_WreRR2Za',
  );
//apijlhhescaneunlxcjp
=======
    url: 'https://psbvfcqtjiitnbuurlkd.supabase.co',
    anonKey: 'sb_publishable_sMuiVlT9_I7aMkW5Mxm-IA_U4_j7BAe',
  );

>>>>>>> 71e363e9e57e6f331681c6680a26430d8356d3c8
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
