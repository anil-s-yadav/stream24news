import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream24news/samplepage.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';

import '../../../features/bookmarkPage/bookmark_page.dart';
import '../../../features/notification/notification.dart';

class HomePage extends StatefulWidget {
  final Function(int) changeTab; // Receive function from BottomNavbar
  const HomePage({super.key, required this.changeTab});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Samplepage()));
          },
          child: Row(
            children: [
              Text(
                "Stream24 ",
                style: GoogleFonts.dancingScript(fontWeight: FontWeight.bold),
              ),
              Text(
                "News",
                style: GoogleFonts.dancingScript(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 5),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationPage()));
                },
                child: const Icon(MyTabIcons.notification)),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookmarkPage()));
              },
              child: const Icon(
                MyTabIcons.bookmark,
                size: 21,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    widget.changeTab(1); // Switch to Live TV tab
                  },
                  child: titleheading(context, "", "See All >")),
              sizedBoxH5,
              SizedBox(
                height: 100,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (BuildContext cotext, int index) {
                      return Image.asset(
                        "lib/assets/images/profile.png",
                        scale: 1.5,
                      );
                    }),
              ),
              sizedBoxH5,
              Container(
                margin: const EdgeInsets.all(5),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                ),
                child: Center(
                    child: Text("Banner ad",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ))),
              ),
              sizedBoxH10,
              titleheading(context, "Trending", "See All"),
              sizedBoxH10,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    trendingPosts(context),
                    sizedBoxW10,
                    trendingPosts(context),
                    sizedBoxW10,
                    trendingPosts(context),
                    sizedBoxW10,
                    trendingPosts(context),
                    sizedBoxW10,
                  ],
                ),
              ),
              sizedBoxH20,
              Text(
                " See all catogeries    >",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              sizedBoxH10,
              SizedBox(
                width: double.infinity,
                height: 32,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          height: 2,
                          width: 100,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              color: selectedIndex != index
                                  ? Theme.of(context).colorScheme.surface
                                  : Theme.of(context).colorScheme.surfaceTint,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  width: 1,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          child: Center(
                            child: Text(
                              "Politics",
                              style: TextStyle(
                                color: selectedIndex != index
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              sizedBoxH20,
              titleheading(context, "Recomanded", "See All"),
              recomendedPosts(context),
              recomendedPosts(context),
              Container(
                margin: const EdgeInsets.all(5),
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
              recomendedPosts(context),
              recomendedPosts(context),
              sizedBoxH20,
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BookmarkPage()));
                  },
                  child: titleheading(context, "Saved", "See All ")),
              sizedBoxH5,
              Row(
                children: [
                  savedPosts(context),
                  savedPosts(context),
                ],
              ),
              sizedBoxH20,
              Container(
                margin: const EdgeInsets.all(5),
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
              sizedBoxH20,
              GestureDetector(
                  onTap: () {
                    widget.changeTab(1);
                  },
                  child: titleheading(context, "Live channels", "See All ")),
              sizedBoxH5,
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                shrinkWrap: true,
                children: List.generate(
                  6,
                  (index) {
                    return Container(
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerLow,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "lib/assets/images/profile.png",
                              scale: 1.5,
                            ),
                            sizedBoxH5,
                            Text(
                              maxLines: 1,
                              "Channel Name",
                              style: Theme.of(context).textTheme.labelSmall,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              sizedBoxH5,
              Container(
                margin: const EdgeInsets.all(5),
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
        ),
      ),
    );
  }

  Widget trendingPosts(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          //height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "lib/assets/images/test_sample1.jpg",
                  fit: BoxFit.fill,
                ),
              ),
              sizedBoxH5,
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: Text(
                    style: Theme.of(context).textTheme.labelMedium,
                    "You should know how to make web requests in your chosen programming language"),
              ),
              sizedBoxH5,
              Row(
                //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  sizedBoxW5,
                  Image.asset(
                    "lib/assets/images/profile.png",
                    scale: 7,
                  ),
                  sizedBoxW5,
                  const Text(
                    "Anil Yadav",
                    style: TextStyle(fontSize: 10),
                    softWrap: true,
                  ),
                  sizedBoxW5,
                  const Text(
                    "1 day ago",
                    softWrap: true,
                    style: TextStyle(fontSize: 10),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.more_vert_outlined,
                    size: 18,
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget recomendedPosts(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surfaceContainer),
      child: ListTile(
        leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              "lib/assets/images/military.jpg",
            )),
        title: Text(
          "To get started you'll need an API key. They're free while you are in development.",
          style: Theme.of(context).textTheme.titleSmall,
          maxLines: 2,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Row(
            children: [
              Image.asset(
                "lib/assets/images/profile.png",
                scale: 9,
              ),
              sizedBoxW5,
              const Text(
                "Anil Yadav",
                style: TextStyle(fontSize: 10),
                softWrap: true,
              ),
              sizedBoxW5,
              const Text(
                "1 day ago",
                softWrap: true,
                style: TextStyle(fontSize: 10),
              ),
              const Spacer(),
              const Icon(
                Icons.more_vert_outlined,
                size: 18,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget titleheading(BuildContext context, String text, String seeall) {
    return Row(
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(
            right: 8,
          ),
          child: Text(
            seeall,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
      ],
    );
  }

  Widget savedPosts(BuildContext context) {
    return SizedBox(
      height: 140,
      width: MediaQuery.of(context).size.width / 2.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyLightContainer(
            height: 110,
            width: MediaQuery.of(context).size.width / 2.1,
            child: const Text("Datkka"),
          ),
          Row(
            children: [
              sizedBoxW15,
              Image.asset(
                "lib/assets/images/profile.png",
                scale: 9,
              ),
              sizedBoxW5,
              const Text(
                "Anil Yadav",
                style: TextStyle(fontSize: 10),
                softWrap: true,
              ),
              sizedBoxW5,
              const Text(
                "1 day ago",
                softWrap: true,
                style: TextStyle(fontSize: 10),
              ),
              const Spacer(),
              const Icon(
                Icons.more_vert_outlined,
                size: 18,
              )
            ],
          ),
        ],
      ),
    );
  }
}
