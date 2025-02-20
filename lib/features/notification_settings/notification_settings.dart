import 'package:flutter/material.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool allNotificationSwitch = true;
  bool breakingNewsSwitch = true;
  bool trendingNewsSwitch = true;
  bool dailyNewsSwitch = true;
  bool weeklyNewsSwitch = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            sizedBoxH15,
            SwitchListTile(
                title: Text(
                  "Allow all notifications",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                value: allNotificationSwitch,
                onChanged: (var value) {
                  setState(() {
                    allNotificationSwitch = value;
                  });
                }),
            const Divider(
              endIndent: 10,
              indent: 10,
            ),
            sizedBoxH20,
            switchUi(
              "Breaking news notifications",
              breakingNewsSwitch,
              (value) {
                setState(() {
                  breakingNewsSwitch = value;
                });
              },
            ),
            switchUi(
              "Trending news notifications",
              trendingNewsSwitch,
              (value) {
                setState(() {
                  trendingNewsSwitch = value;
                });
              },
            ),
            switchUi(
              "Daily news notifications",
              dailyNewsSwitch,
              (value) {
                setState(() {
                  dailyNewsSwitch = value;
                });
              },
            ),
            switchUi(
              "Weekly news notifications",
              weeklyNewsSwitch,
              (value) {
                setState(() {
                  weeklyNewsSwitch = value;
                });
              },
            ),
            sizedBoxH30,
            TersoryButton(
                text: "reset all settings!",
                onPressed: () {
                  setState(() {
                    allNotificationSwitch = true;
                    breakingNewsSwitch = true;
                    trendingNewsSwitch = true;
                    dailyNewsSwitch = true;
                    weeklyNewsSwitch = true;
                  });
                })
          ],
        ),
      ),
    );
  }

  Widget switchUi(String text, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
