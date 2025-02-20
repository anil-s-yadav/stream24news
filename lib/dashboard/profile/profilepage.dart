import 'package:flutter/material.dart';
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
              child: Icon(
                Icons.share,
              ),
            ),
            sizedBoxW20,
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
              child: Icon(
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
                CircleAvatar(
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
                    Text("anilyadav@gmail.com"),
                  ],
                )
              ],
            ),
            Divider(
              indent: 10,
              endIndent: 10,
            ),
            sizedBoxH30,
            MyLightContainer(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListTile(
                leading: Icon(
                  Icons.edit,
                  size: 26,
                ),
                title: Text("Edit Profile",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                ),
              ),
            ),
            sizedBoxH10,
            MyLightContainer(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListTile(
                leading: Icon(
                  Icons.star_rate_rounded,
                  size: 26,
                ),
                title: Text("Rate us",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                ),
              ),
            ),
            sizedBoxH10,
            MyLightContainer(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListTile(
                leading: Icon(
                  Icons.call,
                  size: 26,
                ),
                title: Text("Contact developer",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
              child: Text("Try our other Apps!"),
            )
          ]),
        ));
  }
}
