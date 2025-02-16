import 'package:flutter/material.dart';
import '../dashboard/homepage/homepage.dart';

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
              icon: Image.asset(
                selectedIndex == 0
                    ? "lib/assets/images/home-button-fill.png"
                    : "lib/assets/images/home-button.png",
                scale: 5,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Image.asset(
                selectedIndex == 1
                    ? "lib/assets/images/video-fill.png"
                    : "lib/assets/images/video.png",
                scale: 5,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Image.asset(
                selectedIndex == 2
                    ? "lib/assets/images/newspaper-fill.png"
                    : "lib/assets/images/newspaper.png",
                scale: 5.2,
              ),
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
