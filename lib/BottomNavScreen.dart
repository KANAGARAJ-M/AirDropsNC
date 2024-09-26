// import 'package:air_drops/Screen/bottomNavScreen/Events.dart';
// import 'package:air_drops/Screen/bottomNavScreen/Profile.dart';
// import 'package:air_drops/Screen/bottomNavScreen/Upgrades.dart';
// import 'package:air_drops/Screen/bottomNavScreen/refer.dart';
// import 'package:air_drops/Screen/newm.dart';
// import 'package:flutter/material.dart';

// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0;
//   final List<Widget> _children = [
//     ItemListScreen(),
//     const UpgradesScreen(),
//     const EventsPage(),
//     const ReferScreen(),
//     const ProfileScreen(),
//   ];

//   void _onTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _children[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
//         fixedColor: const Color.fromARGB(255, 0, 0, 0),
//         selectedItemColor: Colors.black,
//         currentIndex: _currentIndex,
//         onTap: _onTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home', // Added label
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.upgrade),
//             label: 'Upgrades', // Added label
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.event),
//             label: 'Events', // Added label
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_add_alt),
//             label: 'Refer', // Added label
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile', // Added label
//           ),
//         ],
//       ),
//     );
//   }
// }


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
    UpgradesScreen(),
    EventsPage(),
    ReferScreen(),
    ProfileScreen(),
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
        backgroundColor: Colors.black, // Set background color to black
        selectedItemColor: Colors.white, // Set selected item color to white
        unselectedItemColor: Colors.grey, // Set unselected item color to grey
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upgrade),
            label: 'Upgrades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt),
            label: 'Refer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
