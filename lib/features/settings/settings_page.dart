import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:stream24news/auth/create_account/select_cuntory.dart';
import 'package:stream24news/auth/create_account/select_language.dart';
import 'package:stream24news/auth/auth_service.dart';
import 'package:stream24news/features/notification_settings/notification_settings.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/services/shared_pref_service.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';
import 'package:stream24news/utils/theme/theme_provider.dart';

import '../../auth/login/login_options_page.dart';
import '../single_pages/aboutus_page.dart';
import '../single_pages/contact_page.dart';
import '../../dashboard/profile/personal_info_page.dart';
import '../single_pages/privacy_policy.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isLoggedIn = false;
  List<String>? language;
  List<String>? countrty;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    isLoggedIn = AuthService().isUserLoggedIn();

    language = SharedPrefService().getLanguage() ?? ["English", "en"];
    countrty = SharedPrefService().getCounty() ??
        ["https://flagcdn.com/36x27/in.png", "india", "In"];
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
              settingTile(
                icon: Image.asset(
                  "lib/assets/images/user_1.png",
                  color: Theme.of(context).colorScheme.onSurface,
                  scale: 2.4,
                ),
                title: "Personal Info",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PersonalInfoPage()));
                },
              ),
              settingTile(
                icon: Icon(
                  MyTabIcons.notification,
                ),
                title: "Notification",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationSettings()));
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const SelectLanguage(commingFrom: 'settings')));
                },
                child: ListTile(
                  leading: Icon(
                    Icons.translate_rounded,
                    size: 26,
                  ),
                  title: Text("Language",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20.0,
                    children: [
                      Text('${language![0]} (${language![1]})',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const SelectCuntory(commingFrom: 'settings')));
                },
                child: ListTile(
                  leading: Image.network(
                    countrty![0],
                    width: 20,
                    height: 20,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.flag_outlined),
                  ),
                  title: Text("Country",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20.0,
                    children: [
                      Text('${countrty![1]} (${countrty![2]})',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                      ),
                    ],
                  ),
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
              settingTile(
                icon: Icon(
                  Icons.code,
                  size: 26,
                ),
                title: "Contact developer",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ContactUsPage()));
                },
              ),
              settingTile(
                  icon: Icon(
                    Icons.help_outline,
                    size: 26,
                  ),
                  title: "Help Center",
                  onTap: () => EasyLoading.showInfo(
                      "Will be implemented after uploaded on play store!")),
              settingTile(
                  icon: Icon(
                    Icons.lock_outlined,
                    size: 26,
                  ),
                  title: "Privacy Policy",
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrivacyPolicy()))),
              settingTile(
                  icon: Icon(
                    Icons.info_outline_rounded,
                    size: 26,
                  ),
                  title: "About Stream24 News App",
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AboutusPage()));
                  }),
              GestureDetector(
                onTap: () {
                  if (isLoggedIn) {
                    logOut(); //dialog box call
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
                  title: Text(isLoggedIn ? "Logout" : "Sign in",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error,
                      )),
                ),
              ),
              /*   sizedBoxH5(context),
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
              sizedBoxH15(context), */
            ],
          ),
        ));
  }

  Widget settingTile({
    required Widget icon,
    required String title,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: icon,
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
        ),
      ),
    );
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
                await AuthService().signOut();
              } catch (e) {
                throw Exception(e);
              }

              if (context.mounted) {
                Navigator.pop(context);
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
