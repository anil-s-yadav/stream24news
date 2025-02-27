import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream24news/utils/theme/theme_provider.dart';
// import 'onboarding_screen/onboarding.dart';
// import 'utils/componants/bottom_navbar.dart';
import 'auth/create_account/select_cuntory.dart';
import 'auth/presentation/login_options_page.dart';
import 'utils/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      //  home: const BottomNavbar(),
      // home: const OnboardingScreen(),
      home: const LoginOptionsPage(),
      // home: const SelectCuntory(),
    );
  }
}
