import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          Row(
            children: [
              sizedBoxW15(context),
              const CircleAvatar(
                radius: 50,
                foregroundImage: AssetImage("lib/assets/images/profile.png"),
              ),
              sizedBoxW20(context),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Anil S. Yadav",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Text("anilyadav@gmail.com"),
                ],
              )
            ],
          ),
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
                      child: Text(value),
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
          Spacer(),
          const Text(
            "This app is free to use. You can support the developer by",
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
          ),
          Padding(
            padding: const EdgeInsets.all(11),
            child: Image.asset(
              'lib/assets/images/buymeacopy.png',
              scale: 10,
            ),
          ),
        ],
      ),
    );
  }
}
