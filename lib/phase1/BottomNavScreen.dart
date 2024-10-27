//ANIMATED
import 'package:air_drops/phase1/Screen/bottomNavScreen/Profile.dart';
import 'package:air_drops/phase1/Screen/bottomNavScreen/Community.dart';
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






  // late FirebaseRemoteConfig _remoteConfig;
  // bool _isUpdateRequired = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _checkForAppUpdate(); // Check for app update on startup
  // }

  @override
  void initState() {
    super.initState();
    // _checkForAppUpdate();
    _pageController = PageController(initialPage: _currentIndex);
  }

  // Future<void> _checkForAppUpdate() async {
  //   _remoteConfig = FirebaseRemoteConfig.instance;

  //   try {
  //     // Fetch and activate remote config
  //     await _remoteConfig.setConfigSettings(RemoteConfigSettings(
  //       fetchTimeout: Duration(minutes: 1),
  //       minimumFetchInterval: Duration(hours: 1),
  //     ));
  //     await _remoteConfig.fetchAndActivate();

  //     // Get current app version using package_info_plus
  //     final packageInfo = await PackageInfo.fromPlatform();
  //     String currentVersion = packageInfo.version;

  //     // Get minimum required version from Firebase Remote Config
  //     String minimumVersion = _remoteConfig.getString('minimum_version');

  //     // Check if the current version is less than the minimum version
  //     if (_isVersionOutdated(currentVersion, minimumVersion)) {
  //       _isUpdateRequired = true;
  //       _showUpdateDialog(context, minimumVersion); // Show update dialog
  //     }
  //   } catch (error) {
  //     print('Error fetching remote config: $error');
  //   }
  // }

  // // Compare app versions (return true if update is needed)
  // bool _isVersionOutdated(String currentVersion, String minimumVersion) {
  //   final currentParts = currentVersion.split('.').map(int.parse).toList();
  //   final minimumParts = minimumVersion.split('.').map(int.parse).toList();

  //   for (int i = 0; i < minimumParts.length; i++) {
  //     if (currentParts[i] < minimumParts[i]) return true;
  //     if (currentParts[i] > minimumParts[i]) return false;
  //   }
  //   return false;
  // }

  // // Show update dialog
  // void _showUpdateDialog(BuildContext context, String minimumVersion) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false, // Prevent dismissing the dialog
  //     builder: (BuildContext context) {
  //       return WillPopScope(
  //         onWillPop: () async => false, // Disable back button
  //         child: AlertDialog(
  //           title: Text('Update Required'),
  //           content: Text(
  //               'A new version of the app ($minimumVersion) is available. Please update to continue.'),
  //           actions: <Widget>[
  //             TextButton(
  //               child: Text('Update Now'),
  //               onPressed: () {
  //                 _launchAppStore(); // Launch the app store for updating
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // // Launch app store
  // Future<void> _launchAppStore() async {
  //   const url = 'https://play.google.com/store/apps/details?id=airdrops.nocorps.xyz'; // Replace with your app's Play Store link
  //   final String linkAppOpen = url;
  //   final Uri _url = Uri.parse(linkAppOpen);
  //   await launchUrl(
  //     _url,
  //     mode: LaunchMode.platformDefault,
  //     webViewConfiguration: const WebViewConfiguration(
  //       enableJavaScript: true,
  //     ),
  //   );
  // }

  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut, // Smooth animation curve
    );
  }

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
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // Update the selected tab
          });
        },
        children: [
           const TasksScreenPage(),
           const CommunityPage(),
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
        unselectedItemColor: Colors.black54, // Set unselected item color to grey
        type: BottomNavigationBarType.fixed, // Keeps items fixed in place
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Community',
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
