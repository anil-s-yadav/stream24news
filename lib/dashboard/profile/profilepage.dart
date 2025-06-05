import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stream24news/auth/login/login_options_page.dart';
import 'package:stream24news/dashboard/profile/edit_profile_page.dart';
import 'package:stream24news/features/single_pages/donation_page.dart';
import 'package:stream24news/utils/componants/my_methods.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/services/shared_pref_service.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';
import '../../auth/auth_service.dart';
import '../../features/settings/settings_page.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final List<String> _setHomepageList = ["Home", "Live TV", "Articles"];
  String _currentSelectedValue = "Home";

  User? user;
  bool isLoggedIn = false;
  String photo = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    user = AuthService().getUser();
    isLoggedIn = AuthService().isUserLoggedIn();
    _currentSelectedValue = SharedPrefService().getDefaultHomePage() ?? "Home";

    setState(() {
      photo = user?.photoURL ?? defaultImageUrl;
    });
  }

  void handleRateUs() async {
    try {
      const url =
          'https://play.google.com/store/apps/details?id=com.legendarysoftware.stream24news';
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        EasyLoading.showInfo('Could not launch $url');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void shareApp() {
    const url =
        'https://play.google.com/store/apps/details?id=com.legendarysoftware.stream24news';
    try {
      Share.share(
          '$url\n\nExperience live news, trending articles, and more — all in one app!'
          // subject: 'Check out this app for Live news and Quick updates!',
          );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: shareApp, icon: const Icon(Icons.share)),
          sizedBoxW20(context),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ),
            child: const Icon(MyTabIcons.settings),
          ),
          sizedBoxW30(context),
        ],
      ),
      body: Column(
        children: [
          if (isLoggedIn)
            Row(
              children: [
                sizedBoxW15(context),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: photo,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          const CircularProgressIndicator(strokeWidth: 2),
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.person, size: 40),
                    ),
                  ),
                ),
                sizedBoxW20(context),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? "User",
                      style: theme.textTheme.headlineMedium,
                    ),
                    Text(user?.email ?? ""),
                  ],
                ),
              ],
            ),
          if (!isLoggedIn)
            GestureDetector(
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginOptionsPage()),
              ),
              child: MyLightContainer(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.9,
                child: const Text(
                  "Login",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.red),
                ),
              ),
            ),
          sizedBoxH20(context),
          if (isLoggedIn)
            GestureDetector(
              onTap: () async {
                bool refresh = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()));
                if (refresh == true) {
                  _loadUserData();
                }
              },
              child: MyLightContainer(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.9,
                child: const Text("Edit Profile"),
              ),
            ),
          GestureDetector(
            onTap: handleRateUs,
            // onTap: () => EasyLoading.showInfo("status"),
            child: MyLightContainer(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.9,
              child: const Center(
                child: Text(
                  "⭐ Rate Us",
                ),
              ),
            ),
          ),
          MyLightContainer(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Select home page"),
                DropdownButton(
                  value: _currentSelectedValue,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() => _currentSelectedValue = newValue.toString());
                    SharedPrefService()
                        .setDefaultHomePage(_currentSelectedValue);
                  },
                  items: _setHomepageList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: theme.textTheme.labelLarge!.copyWith(
                          color: theme.colorScheme.shadow,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                IconButton(
                  onPressed: () {
                    showAboutDialog(
                      context: context,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          "This app has three main entry points to suit your preferences:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: "• ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: "Home Page\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                text:
                                    "Access everything in one place — Live Channels, News Articles, Saved Stories, Trending, and Recommendations.",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: "• ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: "Live TV\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                text:
                                    "Instantly start watching live channels upon opening the app. No setup, just tap and stream.",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: "• ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: "Articles\n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                text:
                                    "For a clean reading experience, directly enter the article section. Swipe up to explore the latest news updates.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  icon: Icon(Icons.info_outline,
                      color: theme.colorScheme.outline),
                )
              ],
            ),
          ),
          sizedBoxH10(context),
          const Divider(indent: 10, endIndent: 10),
          const Spacer(),
          const Text(
            "This app is free to use. You can support the developer by",
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 11),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DonationPage(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(11),
              child: Card(
                elevation: 5,
                child: Image.asset(
                  'lib/assets/images/buymeacopy.png',
                  scale: 9,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
