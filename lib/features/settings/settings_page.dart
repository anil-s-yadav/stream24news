import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream24news/auth/network/auth_service.dart';
import 'package:stream24news/features/notification_settings/notification_settings.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/services/shared_pref_service.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';
import 'package:stream24news/utils/theme/theme_provider.dart';

import '../../auth/login/login_options_page.dart';
import '../../utils/componants/bottom_navbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool? isLogin = true;
  bool? isBoadingScreenDone = false;
  final sharedPrefs = SharedPrefService();
  final _myAuth = AuthService();

  @override
  void initState() {
    super.initState();
    setState(() {
      isLogin = sharedPrefs.getBool("is_userlogged_key");
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Settings",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: Text(
                  "Settings",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                title: const Divider(),
              ),
              ListTile(
                leading: Image.asset(
                  "lib/assets/images/user_1.png",
                  scale: 2.4,
                ),
                title: Text("Personal Info",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationSettings()));
                },
                child: const ListTile(
                  leading: Icon(
                    MyTabIcons.notification,
                    //size: 30,
                  ),
                  title: Text("Notification",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                  ),
                ),
              ),
              const ListTile(
                leading: Icon(
                  Icons.shield_outlined,
                  size: 26,
                ),
                title: Text("Security",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                ),
              ),
              const ListTile(
                leading: Icon(
                  MyTabIcons.listview,
                  size: 26,
                ),
                title: Text("Language",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20.0,
                  children: [
                    Text("English (In)",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                    ),
                  ],
                ),
              ),
              SwitchListTile(
                title: const Text(
                  'Dark Mode',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                secondary: const Icon(
                  Icons.remove_red_eye_outlined,
                  size: 26,
                ),
                value:
                    themeProvider.isDarkMode(context), //  Fixed: Uses context
                onChanged: (bool value) {
                  themeProvider.toggleTheme(value);
                },
              ),
              sizedBoxH10(context),
              ListTile(
                leading: Text(
                  "About",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                title: const Divider(),
              ),
              const ListTile(
                leading: Icon(
                  Icons.code,
                  size: 26,
                ),
                title: Text("Contact developer",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                ),
              ),
              const ListTile(
                leading: Icon(
                  Icons.help_outline,
                  size: 26,
                ),
                title: Text("Help Center",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                ),
              ),
              const ListTile(
                leading: Icon(
                  Icons.lock_outlined,
                  size: 26,
                ),
                title: Text("Privacy Policy",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                ),
              ),
              const ListTile(
                leading: Icon(
                  Icons.info_outline_rounded,
                  size: 26,
                ),
                title: Text("About Stream24 News App",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (isLogin == true) {
                    logOut();
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginOptionsPage()),
                    );
                  }
                },
                child: ListTile(
                  leading: Icon(
                    Icons.logout_outlined,
                    size: 26,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(isLogin == true ? "Logout" : "Sign in",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error,
                      )),
                ),
              ),
              sizedBoxH5(context),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Center(
                    child: Text("Banner ad",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ))),
              ),
              sizedBoxH15(context),
            ],
          ),
        ));
  }

  void logOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout!"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              try {
                final user = await _myAuth.signOut();
              } catch (e) {
                print("Something went wrong. Please try again.");
              }

              Navigator.pop(context);

              await sharedPrefs.setBool("is_userlogged_key", false);

              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginOptionsPage()),
                  (route) => false, // Removes all previous routes
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
