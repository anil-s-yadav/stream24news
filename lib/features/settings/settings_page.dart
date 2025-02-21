import 'package:flutter/material.dart';
import 'package:stream24news/features/notification_settings/notification_settings.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkSwitchToggle = false;
  @override
  Widget build(BuildContext context) {
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
              const ListTile(
                leading: Icon(
                  Icons.person_outlined,
                  size: 35,
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
                  title: const Text("Dark Mode",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  secondary: const Icon(
                    Icons.remove_red_eye_outlined,
                    size: 26,
                  ),
                  value: darkSwitchToggle,
                  onChanged: (bool value) {
                    setState(() {
                      darkSwitchToggle = value;
                    });
                  }),
              sizedBoxH10,
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
              ListTile(
                leading: Icon(
                  Icons.logout_outlined,
                  size: 26,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text("Logout",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.error,
                    )),
              ),
              sizedBoxH5,
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
              sizedBoxH15,
            ],
          ),
        ));
  }
}
