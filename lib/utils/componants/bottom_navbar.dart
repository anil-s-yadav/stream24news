import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream24news/dashboard/profile/profilepage.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';
import '../../dashboard/homepage/homepage.dart';
import '../../dashboard/livetvpage/livetvpage.dart';
import '../../dashboard/newspage/newspage.dart';

class BottomNavbar extends StatefulWidget {
  final int index;
  const BottomNavbar({super.key, this.index = 0}); // default to 0

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar>
    with AutomaticKeepAliveClientMixin {
  late int selectedIndex;
  late final PageController _pageController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.index;
    _pageController = PageController(initialPage: selectedIndex);
  }

  void changeTab(int index) {
    if (index == selectedIndex || !_pageController.hasClients) return;

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => selectedIndex = index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (await _onWillPop()) {
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
          physics:
              const NeverScrollableScrollPhysics(), // Disable swipe gesture
          children: const [HomePage(), LiveTvPage(), Newspage(), Profilepage()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: changeTab,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            _buildNavItem(
                0, MyTabIcons.home_button, MyTabIcons.home_button_fill),
            _buildNavItem(1, MyTabIcons.video, MyTabIcons.video_fill),
            _buildNavItem(2, MyTabIcons.newspaper, MyTabIcons.newspaper_fill),
            BottomNavigationBarItem(
              icon: Image.asset("lib/assets/images/profile.png", scale: 5),
              label: "",
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      int index, IconData icon, IconData activeIcon) {
    return BottomNavigationBarItem(
      icon: Icon(selectedIndex == index ? activeIcon : icon),
      label: "",
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
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Exit"),
              ),
            ],
          ),
        ) ??
        false;
  }
}
