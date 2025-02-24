import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

import '../utils/componants/bottom_navbar.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<OnboardingData> _pages = [
    OnboardingData(
        title: "Quick News Summaries",
        discription:
            "Stay informed in seconds!. Get short, to-the-point news summaries and never miss an update.",
        image: "lib/assets/lottie_json/test1.json"),
    OnboardingData(
        title: "Scroll & Enjoy!",
        discription:
            "Enjoy news in a reels-like experience. Just scroll up for the next story.",
        image: "lib/assets/lottie_json/scrollphone.json"),
    OnboardingData(
        title: "Live TV Access",
        discription:
            "Stream 100+ live news channels anytime, any language anywhere—stay ahead of the headlines.",
        image: "lib/assets/lottie_json/livetv.json"),
    OnboardingData(
        title: "Personalized News Feed",
        discription:
            "News that matters to you!. Follow your favorite topics and get a feed tailored to your interests.",
        image: "lib/assets/lottie_json/personalized.json"),
    OnboardingData(
        title: "Reading Comfort",
        discription:
            "Read your way!. Choose themes and colors that suit your eyes for a comfortable reading experience.",
        image: "lib/assets/lottie_json/comfort.json"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            sizedBoxH30,
            Row(
              children: [
                Spacer(),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BottomNavbar()));
                    },
                    child: const Text("Skip")),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.67,
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (value) {
                    setState(() {
                      _currentPage = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPage(data: _pages[index]);
                  }),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(
                                        _currentPage == index ? 255 : 200),
                                borderRadius: BorderRadius.circular(8)),
                          )),
                ),
                sizedBoxH15,
                SizedBox(
                  height: 70,
                  child: Row(
                    children: [
                      if (_currentPage > 0)
                        SecondaryButton(
                            text: "Back",
                            onPressed: () {
                              _pageController.previousPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);
                            }),
                      const Spacer(),
                      _currentPage != 4
                          ? IconButton(
                              onPressed: () {
                                _pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut);
                              },
                              icon: Icon(
                                Icons.arrow_circle_right,
                                size: 55,
                                color: Theme.of(context).colorScheme.primary,
                              ))
                          : PrimaryButton(
                              text: "Get Started",
                              onPressed: () {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             const BottomNavbar()));
                              })
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String discription;
  final String image;
  OnboardingData({
    required this.title,
    required this.discription,
    required this.image,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  const OnboardingPage({super.key, required this.data});
//  final String lottieimage = "lib/assets/lottie_json/scrollphone.json";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            data.image,
          ),
          // data.image == lottieimage
          //     ? Lottie.asset(
          //         data.image,
          //       )
          //     : Image.asset(
          //         data.image,
          //         scale: 5,
          //       ),
          sizedBoxH30,
          Text(
            data.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          sizedBoxH30,
          Text(
            data.discription,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          )
        ],
      )),
    );
  }
}
