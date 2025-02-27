import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

import '../auth/presentation/login_options_page.dart';

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
        image: "lib/assets/lottie_json/test.json"),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.015,
                right: MediaQuery.of(context).size.height * 0.02,
                child: TextButton(
                    style: TextButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Colors.black12.withAlpha(10)),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginOptionsPage()));
                    },
                    child: const Text("Skip")),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
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
                  Row(
                    mainAxisAlignment: _currentPage == 0
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: TersoryButton(
                              textWidget: Text("Back"),
                              onPressed: () {
                                _pageController.previousPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut);
                              }),
                        ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: PrimaryButton(
                            textWidget: Text(
                                _currentPage != 4 ? "Next" : "Get Started"),
                            onPressed: () {
                              if (_currentPage == 4) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginOptionsPage()));
                              } else {
                                _pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut);
                              }
                            }),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
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
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            child: Lottie.asset(
              data.image,
            ),
          ),
          sizedBoxH10(context),
          Text(
            data.title,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold),

            // TextStyle(
            //    ),
          ),
          sizedBoxH20(context),
          Text(
            data.discription,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: MediaQuery.of(context).size.width * 0.038,
                ),
            textAlign: TextAlign.center,
          )
        ],
      )),
    );
  }
}
