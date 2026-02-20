import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hungry/pages/auth/screens/rest_password.dart';
import 'package:hungry/pages/spalsh_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';




final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();
Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://psbvfcqtjiitnbuurlkd.supabase.co',
    anonKey: 'sb_publishable_sMuiVlT9_I7aMkW5Mxm-IA_U4_j7BAe',
  );

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // ✅ LISTEN ONCE — GLOBAL
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final event = data.event;

    if (event == AuthChangeEvent.passwordRecovery) {
      navigatorKey.currentState
          ?.pushReplacement(
            MaterialPageRoute(builder: (context) => ResetPassword(),)
          );
    }
  });
  runApp(const MyApp());
}

// Get a reference your Supabase client
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
