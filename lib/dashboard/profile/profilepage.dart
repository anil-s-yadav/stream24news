import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream24news/auth/login/login_options_page.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/services/shared_pref_service.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';

import '../../features/settings/settings_page.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final List<String> _setHomepageList = [
    "Home",
    "Live TV",
    "Articals",
  ];
  String _currentSelectedValue = "Home";
  final user = FirebaseAuth.instance.currentUser;
  //final user = auth.currentUser;
  bool isLogin = false;
  String? photo;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLogin = SharedPrefService().getLoginDoneBool() ?? false;
      photo = SharedPrefService().getProfilePhoto();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            // onTap: () {
            //   Navigator.push(context,
            //       MaterialPageRoute(builder: (context) => SettingsPage()));
            // },
            child: const Icon(
              Icons.share,
            ),
          ),
          sizedBoxW20(context),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
            child: const Icon(
              MyTabIcons.settings,
            ),
          ),
          sizedBoxW30(context),
        ],
      ),
      body: Column(
        children: [
          Visibility(
            visible: isLogin,
            child: Row(
              children: [
                sizedBoxW15(context),
                CircleAvatar(
                  radius: 50,
                  child: CachedNetworkImage(
                    imageUrl: photo ?? "",
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),

                  //  AssetImage("lib/assets/images/profile.png"),
                ),
                sizedBoxW20(context),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? "User",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(user?.email ?? ""),
                  ],
                )
              ],
            ),
          ),
          Visibility(
              visible: !isLogin,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginOptionsPage()),
                  );
                },
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
              )),
          sizedBoxH20(context),
          MyLightContainer(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.9,
            child: const Text("Edit Profile"),
          ),
          MyLightContainer(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.9,
            child: const Text("Rate Us"),
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
                  onChanged: (newValue) {},
                  items: _setHomepageList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.shadow),
                      ),
                      onTap: () {
                        setState(() {
                          _currentSelectedValue = value;
                        });
                      },
                    );
                  }).toList(),
                ),
                Icon(
                  Icons.info_outlined,
                  color: Theme.of(context).colorScheme.outline,
                )
              ],
            ),
          ),
          sizedBoxH10(context),
          const Divider(
            indent: 10,
            endIndent: 10,
          ),
          const Spacer(),
          const Text(
            "This app is free to use. You can support the developer by",
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 11),
          ),
          Padding(
            padding: const EdgeInsets.all(11),
            child: Card(
              elevation: 5,
              child: Image.asset(
                'lib/assets/images/buymeacopy.png',
                scale: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
