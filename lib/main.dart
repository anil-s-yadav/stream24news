import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:stream24news/dashboard/homepage/bloc/homepage_bloc.dart';
import 'package:stream24news/dashboard/livetvpage/bloc/live_tv_bloc.dart';
import 'package:stream24news/features/bookmark/bloc/bookmark_bloc.dart';
import 'package:stream24news/utils/componants/bottom_navbar.dart';
import 'package:stream24news/utils/services/shared_pref_service.dart';
import 'package:stream24news/utils/theme/theme_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'auth/auth_service.dart';
import 'dashboard/newspage/bloc/newspage_bloc.dart';
import 'features/all_categories/bloc/categories_bloc_bloc.dart';
import 'features/search_articles/bloc/search_article_bloc.dart';
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

  configLoading();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..dismissOnTap = false
    ..maskType = EasyLoadingMaskType.black;
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
  String defaultHomePage = "Home";
  bool isDataReady = false;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    isLogin = AuthService().isUserLoggedIn();
    isBoadingScreenDone = SharedPrefService().getOnboadingDoneBool() ?? false;
    isLoginSkipped = SharedPrefService().getLoginSkippedBool() ?? false;
    defaultHomePage = SharedPrefService().getDefaultHomePage() ?? "Home";

    setState(() {
      isDataReady = true;
    });
  }

  Widget getPageWidget() {
    switch (defaultHomePage) {
      case 'Home':
        return const BottomNavbar(index: 0);
      case 'Live TV':
        return const BottomNavbar(index: 1);
      case 'Articles':
        return const BottomNavbar(index: 2);
      default:
        return const BottomNavbar(index: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final textTheme = Theme.of(context).textTheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LiveTvBloc()),
        BlocProvider(create: (context) => HomepageBloc()),
        BlocProvider(create: (context) => CategoriesBlocBloc()),
        BlocProvider(create: (context) => BookmarkBloc()),
        BlocProvider(create: (context) => NewspageBloc()),
        BlocProvider(create: (context) => SearchArticleBloc()),
      ],
      child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Stream24 News',
          theme: MaterialTheme(textTheme).light(),
          darkTheme: MaterialTheme(textTheme).dark(),
          themeMode: themeProvider.themeMode,
          builder: EasyLoading.init(), //  Ensure EasyLoading is initialized
          home: !isDataReady
              ? const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                )
              : !isBoadingScreenDone
                  ? const OnboardingScreen()
                  : isLogin || isLoginSkipped
                      ? getPageWidget()
                      : const LoginOptionsPage()),
    );
  }
}
