import 'package:flutter/material.dart';
import 'package:stream24news/utils/my_tab_icons_icons.dart';
import '../../dashboard/homepage/presentation/homepage.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const HomePage(),
    Container(
        color: Colors.blue, child: const Center(child: Text("Favorites"))),
    Container(color: Colors.green, child: const Center(child: Text("Cart"))),
    Container(
        color: Colors.red, child: const Center(child: Text("User Profile"))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex], // This should update correctly
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
