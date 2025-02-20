import 'package:flutter/material.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Bookmark"),
            bottom: const TabBar(
              labelPadding: EdgeInsets.all(15),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Text("Articals"),
                Text("Channels"),
              ],
            ),
          ),
          body: Center(
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
          )),
    );
  }
}
