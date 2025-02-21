import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';

import '../../features/settings/settings_page.dart';

class Profilepage extends StatelessWidget {
  const Profilepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: Text(
          //   "Best app for LIVE TV and NEWS!",
          //   style: DefaultTextStyle.of(context).style,
          // ),
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
            sizedBoxW20,
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
            sizedBoxW30,
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                sizedBoxW15,
                const CircleAvatar(
                  radius: 50,
                  foregroundImage: AssetImage("lib/assets/images/profile.png"),
                ),
                sizedBoxW20,
                Column(
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

            sizedBoxH20,
            MyLightContainer(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                "Edit Profile",
              ),
            ),
            MyLightContainer(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                "Rate Us",
              ),
            ),
            sizedBoxH10,
            Divider(
              indent: 10,
              endIndent: 10,
            ),
            sizedBoxH20,
            Image.asset(
              'lib/assets/images/buymeacopy.png',
              scale: 8,
            ),
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
            //   child: Text("Try our other Apps!"),
            // )
          ]),
        ));
  }
}
