import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream24news/dashboard/profile/profilepage.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';
import '../../dashboard/homepage/homepage.dart';
import '../../dashboard/livetvpage/livetvpage.dart';
import '../../dashboard/newspage/newspage.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int selectedIndex = 0;
  late final PageController _pageController;

  // List<String> selectedCountry = SharedPrefService().getCounty() ?? [];
  // List<String> selectedLanguage = SharedPrefService().getLanguage() ?? [];

  //   Navigator.pushReplacement(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (context) => selectedLanguage.isEmpty ||
  //                                     selectedCountry.isEmpty
  //                                 ? SelectCuntory()
  //                                 : BottomNavbar()));

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
  }

  void changeTab(int index) {
    setState(() {
      selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        final shouldExit = await _onWillPop();

        if (shouldExit) {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else {
            exit(0);
          }
        }
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => selectedIndex = index);
          },
          children: const [HomePage(), LiveTvPage(), Newspage(), Profilepage()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: changeTab, // Update PageView when tapping tabs
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
                icon: Icon(selectedIndex == 0
                    ? MyTabIcons.home_button_fill
                    : MyTabIcons.home_button),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(selectedIndex == 1
                    ? MyTabIcons.video_fill
                    : MyTabIcons.video),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(selectedIndex == 2
                    ? MyTabIcons.newspaper_fill
                    : MyTabIcons.newspaper),
                label: ""),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "lib/assets/images/profile.png",
                  scale: 5,
                ),
                label: ""),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Exit"),
            content: const Text("Do you really want to exit the app?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Cancel
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Exit
                child: const Text("Exit"),
              ),
            ],
          ),
        ) ??
        false;
  }
}
