import 'package:flutter/material.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';

import '../notification_settings/notification_settings.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notification'),
          bottom: const TabBar(
            labelPadding: EdgeInsets.all(15),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Text("General"), // Fixed typo
              Text("System"),
            ],
          ),
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationSettings()));
                },
                child: const Icon(MyTabIcons.settings, size: 20)),
            sizedBoxW20(context),
          ],
        ),
        body: TabBarView(
          children: [
            generalNotification(context),
            systemNotification(context),
          ],
        ),
      ),
    );
  }

  Widget generalNotification(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, int index) {
            return ListTile(
              leading: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Image.asset(
                    "lib/assets/images/military.jpg",
                  )),
              title: Text(
                maxLines: 2,
                "This is a  Notification Notification This is a  Notification ",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Row(
                children: [
                  Text(
                    "1 day ago | 12:12",
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget systemNotification(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.16,
          ),
          Image.asset(
            "lib/assets/images/empty.png",
            scale: 14,
          ),
          sizedBoxH20(context),
          Text(
            "Empty",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          sizedBoxH10(context),
          const Text(
            "You have not saved anything to the collection!",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
