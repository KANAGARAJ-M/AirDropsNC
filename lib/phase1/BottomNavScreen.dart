//ANIMATED
import 'package:air_drops/phase1/Screen/bottomNavScreen/Profile.dart';
import 'package:air_drops/phase1/Screen/bottomNavScreen/Community.dart';
import 'package:air_drops/phase1/Screen/bottomNavScreen/Ranking/RankingHome.dart';
import 'package:air_drops/phase1/Screen/bottomNavScreen/crypto/CoinAni.dart';
import 'package:air_drops/phase1/Screen/bottomNavScreen/refer.dart';
import 'package:air_drops/phase1/Screen/bottomNavScreen/tasks/TasksScreen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  ///NOT ANIMATED
  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index); // Directly jumps to page without animation
    
  }

  ///ANIMATED
  // void _onTapped(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });
  //   _pageController.animateToPage(
  //     index,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeInOut, // Smooth animation curve
  //   );
  // }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // Update the selected tab
          });
        },
        children: [
          TasksScreenPage(),
          // CommunityPage(),
          RankinghomePage(),
          CoinAnimationScreen(),
          // CoinAnimationScreen(),
          const ReferScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 2.5,
        enableFeedback: false,
        currentIndex: _currentIndex,
        onTap: _onTapped,
        backgroundColor: Colors.teal, // Set background color
        selectedItemColor: Colors.white, // Set selected item color to white
        unselectedItemColor:
            Colors.black54, // Set unselected item color to grey
        type: BottomNavigationBarType.fixed, // Keeps items fixed in place
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tour_sharp),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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
