import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/componants/bottom_navbar.dart';
import 'utils/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final brightness = View.of(context).platformDispatcher.platformBrightness;
    // TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");
    // MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stream24 News',
      theme: ThemeData(
        colorScheme: MaterialTheme.lightScheme(), // ✅ Use custom light theme
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: MaterialTheme.darkScheme(), // ✅ Use custom dark theme
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system, // Auto-switch between light/dark mode
      home: const BottomNavbar(),
    );
  }
}
