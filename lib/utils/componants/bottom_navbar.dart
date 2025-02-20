import 'package:flutter/material.dart';
import 'package:stream24news/dashboard/profile/profilepage.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';
import '../../dashboard/homepage/presentation/homepage.dart';
import '../../dashboard/livetvpage/livetvpage.dart';
import '../../dashboard/newspage/newspage.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int selectedIndex = 0;

  void changeTab(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> screens = [];

  @override
  void initState() {
    super.initState();
    screens.addAll([
      HomePage(changeTab: changeTab), // Pass function to HomePage
      const LiveTvPage(),
      const Newspage(),
      const Profilepage()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
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
    );
  }
}
