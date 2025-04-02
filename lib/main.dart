import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  await SharedPrefService.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );

  configLoading(); // Configure loading styles
  // runApp(
  //   ChangeNotifierProvider(
  //   create: (_) => ThemeProvider(),
  //    child: DevicePreview(
  //     enabled: true,
  //     builder: (context) => ChangeNotifierProvider(
  //       create: (_) => ThemeProvider(),
  //       child: const MyApp(),
  //     ),),
  //   ),
  // );
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;
  bool isBoadingScreenDone = false;
  bool isLoginSkipped = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLogin = SharedPrefService().getLoginDoneBool() ?? false;
      isBoadingScreenDone = SharedPrefService().getOnboadingDoneBool() ?? false;
      isLoginSkipped = SharedPrefService().getLoginSkippedBool() ?? false;
    });
    log('onBoading Main.dart $isBoadingScreenDone');
    log('user login or not Main.dart $isLogin');
    log('login is skipped Main.dart $isLoginSkipped');
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
        builder: EasyLoading.init(), //  Ensure EasyLoading is initialized
        home: !isBoadingScreenDone
            ? const OnboardingScreen()
            : isLogin || isLoginSkipped
                ? const BottomNavbar()
                // : !isLoginSkipped
                //  ? const BottomNavbar()
                : const LoginOptionsPage());
  }
}
