import 'package:air_drops/Screen/bottomNavScreen/Events.dart';
import 'package:air_drops/Screen/bottomNavScreen/Profile.dart';
import 'package:air_drops/Screen/bottomNavScreen/Upgrades.dart';
import 'package:air_drops/Screen/bottomNavScreen/refer.dart';
import 'package:air_drops/Screen/newm.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    ItemListScreen(),
    // FavoritesScreen(),
    // ProfileScreen(),
    UpgradesScreen(),
    EventsPage(),
    ReferScreen(),
    ProfileScreen(),
    // const Center(child: Text("Fav Screen"),),
    // const Center(child: Text("Profile Screen"),),
  ];

  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            // label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upgrade),
            // label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            // label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt),
            // label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            // label: 'Profile',
          ),
        ],
      ),
    );
  }
}
