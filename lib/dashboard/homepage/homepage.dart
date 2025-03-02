import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:stream24news/dashboard/livetvpage/livetvpage.dart';
import 'package:stream24news/samplepage.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';

import '../../features/all_categories/all_categories.dart';
import '../../features/all_categories/category_select.dart';
import '../../features/bookmark/bookmark_page.dart';
import '../../features/notification/notification.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //int selectedIndex = -1;
  final List<Map<String, dynamic>> _categories = categories;

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
                  //  widget.changeTab(1); // Switch to Live TV tab
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LiveTvPage()));
                },
                child: Row(
                  children: [
                    sizedBoxW5(context),
                    Lottie.asset('lib/assets/lottie_json/livetv_title.json',
                        animate: false, height: 15),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 8,
                      ),
                      child: Text(
                        "See All  >",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
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
              sizedBoxH5(context),
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
              sizedBoxH10(context),
              titleheading(context, "Trending", "See All"),
              sizedBoxH10(context),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    trendingPosts(context),
                    sizedBoxW10(context),
                    trendingPosts(context),
                    sizedBoxW10(context),
                    trendingPosts(context),
                    sizedBoxW10(context),
                    trendingPosts(context),
                    sizedBoxW10(context),
                  ],
                ),
              ),
              sizedBoxH30(context),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllCategoriesPage()));
                },
                child: Text(
                  " See all catogeries    >",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 17),
                ),
              ),
              sizedBoxH20(context),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.15,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            //  selectedIndex = index;
                          });
                        },
                        child: categoryCardItem(
                          categories: _categories[index],
                        ),
                      );
                    }),
              ),
              sizedBoxH30(context),
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
              sizedBoxH20(context),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BookmarkPage()));
                  },
                  child: titleheading(context, "Saved", "See All ")),
              sizedBoxH5(context),
              Row(
                children: [
                  savedPosts(context),
                  savedPosts(context),
                ],
              ),
              sizedBoxH20(context),
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
              sizedBoxH20(context),
              GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LiveTvPage()));
                  },
                  child: titleheading(context, "Live channels", "See All ")),
              sizedBoxH5(context),
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
                            sizedBoxH5(context),
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
              sizedBoxH5(context),
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
              sizedBoxH15(context),
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
              sizedBoxH5(context),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: Text(
                    style: Theme.of(context).textTheme.labelMedium,
                    "You should know how to make web requests in your chosen programming language"),
              ),
              sizedBoxH5(context),
              Row(
                //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  sizedBoxW5(context),
                  Image.asset(
                    "lib/assets/images/profile.png",
                    scale: 7,
                  ),
                  sizedBoxW5(context),
                  const Text(
                    "Anil Yadav",
                    style: TextStyle(fontSize: 10),
                    softWrap: true,
                  ),
                  sizedBoxW5(context),
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
              sizedBoxW5(context),
              const Text(
                "Anil Yadav",
                style: TextStyle(fontSize: 10),
                softWrap: true,
              ),
              sizedBoxW5(context),
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
              sizedBoxW15(context),
              Image.asset(
                "lib/assets/images/profile.png",
                scale: 9,
              ),
              sizedBoxW5(context),
              const Text(
                "Anil Yadav",
                style: TextStyle(fontSize: 10),
                softWrap: true,
              ),
              sizedBoxW5(context),
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

  Widget categoryCardItem({required Map<String, dynamic> categories}) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  categories["image"],
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withAlpha(200), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Spacer(),
                  Center(
                    child: Text(
                      categories["title"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  sizedBoxH5(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
