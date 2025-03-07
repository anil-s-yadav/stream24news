import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream24news/utils/componants/bottom_navbar.dart';
import 'package:stream24news/utils/services/shared_pref_service.dart';
import 'package:stream24news/utils/theme/theme_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth/login/login_options_page.dart';
import 'onboarding_screen/onboarding.dart';
import 'utils/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPrefService().init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
  // runApp(
  //   DevicePreview(
  //     enabled: true,
  //     builder: (context) => ChangeNotifierProvider(
  //       create: (_) => ThemeProvider(),
  //       child: const MyApp(),
  //     ),
  //   ),
  // );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;
  bool isBoadingScreenDone = false;

  @override
  void initState() {
    super.initState();
    onBoadingDone();
  }

  void onBoadingDone() async {
    final sharedPrefs = SharedPrefService();
    setState(() {
      isBoadingScreenDone = sharedPrefs.getBool("onBoadingDone_key")!;
      isLogin = sharedPrefs.getBool("is_userlogged_key")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stream24 News',
        theme: MaterialTheme(textTheme).light(),
        darkTheme: MaterialTheme(textTheme).dark(),
        themeMode: themeProvider.themeMode,
        home: !isBoadingScreenDone
            ? const OnboardingScreen()
            : isLogin
                ? const BottomNavbar()
                : const LoginOptionsPage());
  }
}
