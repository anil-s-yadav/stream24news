import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'utils/componants/bottom_navbar.dart';
import 'utils/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stream24 News',
      theme: MaterialTheme(textTheme).light(),
      darkTheme: MaterialTheme(textTheme).dark(),
      themeMode: ThemeMode.system, // Auto-switch between light/dark mode
      home: const BottomNavbar(),
    );
  }
}
