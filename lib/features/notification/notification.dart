import 'package:flutter/material.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            //padding: EdgeInsets.all(10),
            labelPadding: EdgeInsets.all(15),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Text("Ganeral"),
              Text("System"),
            ],
          ),
          title: const Text('Notification'),
          actions: const [
            Icon(
              MyTabIcons.settings,
              size: 20,
            ),
            sizedBoxW20
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
    return ListView.builder(
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
        });
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
          sizedBoxH20,
          Text(
            "Empty",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          sizedBoxH10,
          const Text(
            "You have not saved anything to the collection!",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
