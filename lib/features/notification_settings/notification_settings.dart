import 'package:flutter/material.dart';
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
            sizedBoxH15(context),
            SwitchListTile(
                title: Text(
                  "Allow all notifications",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                value: allNotificationSwitch,
                onChanged: (var value) {
                  setState(() {
                    allNotificationSwitch = value;
                    breakingNewsSwitch = value;
                    trendingNewsSwitch = value;
                    dailyNewsSwitch = value;
                    weeklyNewsSwitch = value;
                  });
                }),
            const Divider(
              endIndent: 10,
              indent: 10,
            ),
            sizedBoxH20(context),
            switchUi(
              "Breaking news notifications",
              breakingNewsSwitch,
              (value) {
                setState(() {
                  breakingNewsSwitch = value;
                  allNotificationSwitch == true
                      ? allNotificationSwitch = false
                      : null;
                });
              },
            ),
            switchUi(
              "Trending news notifications",
              trendingNewsSwitch,
              (value) {
                setState(() {
                  trendingNewsSwitch = value;
                  allNotificationSwitch == true
                      ? allNotificationSwitch = false
                      : null;
                });
              },
            ),
            switchUi(
              "Daily news notifications",
              dailyNewsSwitch,
              (value) {
                setState(() {
                  dailyNewsSwitch = value;
                  allNotificationSwitch == true
                      ? allNotificationSwitch = false
                      : null;
                });
              },
            ),
            switchUi(
              "Weekly news notifications",
              weeklyNewsSwitch,
              (value) {
                setState(() {
                  weeklyNewsSwitch = value;
                  allNotificationSwitch == true
                      ? allNotificationSwitch = false
                      : null;
                });
              },
            ),
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
