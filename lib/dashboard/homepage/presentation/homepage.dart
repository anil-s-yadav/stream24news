import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream24news/samplepage.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/my_tab_icons_icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Samplepage()));
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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(MyTabIcons.notification),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, bottom: 10),
                    child: Text(
                      "See All",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Image.asset(
                      "lib/assets/images/profile.png",
                      scale: 1.5,
                    ),
                    sizedBoxW10,
                    Image.asset(
                      "lib/assets/images/profile.png",
                      scale: 1.5,
                    ),
                    sizedBoxW10,
                    Image.asset(
                      "lib/assets/images/profile.png",
                      scale: 1.5,
                    ),
                    sizedBoxW10,
                    Image.asset(
                      "lib/assets/images/profile.png",
                      scale: 1.5,
                    ),
                    sizedBoxW10,
                    Image.asset(
                      "lib/assets/images/profile.png",
                      scale: 1.5,
                    ),
                    sizedBoxW10,
                    Image.asset(
                      "lib/assets/images/profile.png",
                      scale: 1.5,
                    ),
                    sizedBoxW10,
                    Image.asset(
                      "lib/assets/images/profile.png",
                      scale: 1.5,
                    ),
                  ],
                ),
              ),
              sizedBoxH10,
              Container(
                margin: EdgeInsets.all(5),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.2,
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
              Row(
                children: [
                  Text(
                    "Catogeries",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8,
                    ),
                    child: Text(
                      "See All",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
              sizedBoxH10,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    con(context),
                    sizedBoxW10,
                    con(context),
                    sizedBoxW10,
                    con(context),
                    sizedBoxW10,
                    con(context),
                    sizedBoxW10,
                  ],
                ),
              ),
              sizedBoxH20,
              Row(
                children: [
                  Text(
                    "Catogeries",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8,
                    ),
                    child: Text(
                      "See All",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.primaryContainer),
                child: ListTile(
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset("lib/assets/images/military.jpg")),
                    trailing: Text(
                      "Read more..",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12),
                    ),
                    title: Text("List item")),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.primaryContainer),
                child: ListTile(
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset("lib/assets/images/military.jpg")),
                    trailing: Text(
                      "Read more..",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12),
                    ),
                    title: Text("List item")),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.primaryContainer),
                child: ListTile(
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset("lib/assets/images/military.jpg")),
                    trailing: Text(
                      "Read more..",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12),
                    ),
                    title: Text("List item")),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.primaryContainer),
                child: ListTile(
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset("lib/assets/images/military.jpg")),
                    trailing: Text(
                      "Read more..",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12),
                    ),
                    title: Text("List item")),
              ),
              sizedBoxH10,
              Container(
                margin: EdgeInsets.all(5),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget con(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              "lib/assets/images/military.jpg",
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.fill,
            ),
          ),
          Image.asset(
            "lib/assets/images/blend.png",
            colorBlendMode: BlendMode.darken,
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.fill,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("data", style: Theme.of(context).textTheme.headlineSmall)
            ],
          )
        ],
      ),
    );
  }
}
