import 'drawer.dart';
import 'package:flutter/material.dart';
import 'shop.dart';
import 'wifi_access.dart';
import 'reviews.dart';
import 'colors.dart';

// === HomePage ===
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> bottomNavPages = [
    const Shop(),
    const WifiAccess(),
    const Reviews(),
  ];

  void onBottomNavTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: teaMaxBrown,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('Tea_Max_Logo.png'),
            ),
            SizedBox(width: 10),
            Text("Tea Max"),
          ],
        ),
      ),
      drawer: const DrawerMenu(),
      body: bottomNavPages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        fixedColor: mutedTerracotta,
        onTap: onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(label: "Shop", icon: Icon(Icons.shop_2)),
          BottomNavigationBarItem(label: "Wifi Access", icon: Icon(Icons.wifi)),
          BottomNavigationBarItem(label: "Reiews", icon: Icon(Icons.reviews)),
        ],
      ),
    );
  }
}
