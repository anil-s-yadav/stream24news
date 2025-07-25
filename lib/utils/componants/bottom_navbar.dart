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
  // late final PageController _pageController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.index;
    // _pageController = PageController(initialPage: selectedIndex);
  }

  void changeTab(int index) {
    setState(() => selectedIndex = index);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (selectedIndex == 0) {
          final shouldExit = await _onWillPop();
          if (shouldExit) {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else {
              exit(0);
            }
          }
        } else {
          setState(() {
            selectedIndex = 0;
          });
        }
      },
      child: Scaffold(
        body: _getSelectedPage(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: changeTab,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            _buildNavItem(0, MyTabIcons.homeButton, MyTabIcons.homeButtonFill),
            _buildNavItem(1, MyTabIcons.video, MyTabIcons.videoFill),
            _buildNavItem(2, MyTabIcons.newspaper, MyTabIcons.newspaperFill),
            BottomNavigationBarItem(
              icon: Image.asset("lib/assets/images/profile.png", scale: 5),
              label: "",
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSelectedPage() {
    switch (selectedIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const LiveTvPage();
      case 2:
        return const Newspage();
      case 3:
        return const Profilepage();
      default:
        return const HomePage();
    }
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
