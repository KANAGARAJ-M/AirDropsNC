import 'package:air_drops/phase1/Screen/Splash.dart';
import 'package:air_drops/phase1/customs/GoogleProgressBarC.dart';
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert'; // For parsing JSON

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const UpdateCheckerApp());
// }

// Placeholder app while checking for updates
class UpdateCheckerApp extends StatelessWidget {
  const UpdateCheckerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checking for Updates...',
      home: const NewM(),
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      theme: ThemeData(
        primaryColor: Color(0xFF1E90FF), // Royal Blue
        hintColor: Color(0xFFFF6B6B), // Soft Light Gray
        scaffoldBackgroundColor: Color(0xFFF4F5F7),
        cardColor: Color(0xFFFFFFFF), // Pure White
        textTheme: TextTheme(
          displayLarge: TextStyle(color: Color(0xFF2D2D2D)), // Dark Gray
          bodyLarge: TextStyle(color: Color(0xFF6B6B6B)), // Secondary Gray
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF1E90FF), // Primary button color
          textTheme: ButtonTextTheme.primary,
        ),
        useMaterial3: true,
      ),

      debugShowCheckedModeBanner: false,
    );
  }
}

class UpdateChecker extends StatefulWidget {
  const UpdateChecker({super.key});

  @override
  _UpdateCheckerState createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends State<UpdateChecker> {
  @override
  void initState() {
    super.initState();
    _checkForAppUpdate();
  }

  Future<void> _checkForAppUpdate() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    //Check for network connectivity
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.none) {
    //   // No network connection
    //   _showNoConnectionDialog();
    //   return;
    // }

    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 5),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();

      final packageInfo = await PackageInfo.fromPlatform();
      String currentVersionName = packageInfo.version;
      int currentVersionNumber = int.parse(packageInfo.buildNumber);

      String versionInfoJson = remoteConfig.getString('app_version_info');
      Map<String, dynamic> versionInfo = jsonDecode(versionInfoJson);

      String requiredVersionName = versionInfo['versionName'];
      int requiredVersionNumber = versionInfo['versionNumber'];

      int serVerDorR = remoteConfig.getInt('ServerDown');
      int appUpdate = remoteConfig.getInt('appupdatedown');

      if (_isVersionOutdated(currentVersionName, requiredVersionName,
          currentVersionNumber, requiredVersionNumber)) {
        _showUpdateDialog(requiredVersionName);
      } else if (serVerDorR == 0) {
        _ShowServerDownFunction(serVerDorR);
      } else if (appUpdate == 0) {
        _ShowServerDownForUpdate(appUpdate);
      } else {
        _startApp();
      }
    } catch (error) {
      _showErrorDialog(error.toString());
    }
  }

  bool _isVersionOutdated(String currentVersionName, String requiredVersionName,
      int currentVersionNumber, int requiredVersionNumber) {
    return currentVersionName != requiredVersionName ||
        currentVersionNumber < requiredVersionNumber;
  }

  void _showUpdateDialog(String requiredVersionNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text('Update Required'),
            content: Text(
                'A new version of the app ($requiredVersionNumber) is available. Please update to continue.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Update Now'),
                onPressed: () {
                  _launchAppStore();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _ShowServerDownFunction(int f) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text('Maintenance Down'),
            content: const Text(
                'Server down due to regular maintenance. Please be patient.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Stay Updated'),
                onPressed: () {
                  _stayUpdateWithUS();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _ShowServerDownForUpdate(int f) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text('New Features on the way'),
            content: const Text(
                'We are updating our server and application. Please be patient.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Stay Updated'),
                onPressed: () {
                  _stayUpdateWithUS();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text('No Internet Connection'),
            content: const Text(
                'Please connect to a stable internet connection to proceed.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Close App'),
                onPressed: () {
                  // Close the app
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _launchAppStore() async {
    const url = 'https://play.google.com/store/apps/details?id=anc.nocorps.xyz';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  Future<void> _stayUpdateWithUS() async {
    const url = 'https://x.com/nocorps_dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('Error fetching app version info: $errorMessage'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _startApp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NewM()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: GoogleColorChangingProgressBar(),
      ),
    );
  }
}

class NewM extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const NewM({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AirDrops - NC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}











// import 'package:air_drops/phase1/Screen/Splash.dart';
// import 'package:air_drops/phase1/customs/GoogleProgressBarC.dart';
// import 'package:flutter/material.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:convert'; // For parsing JSON
// import 'package:http/http.dart' as http; // To make HTTP requests

// // Placeholder app while checking for updates
// class UpdateCheckerApp extends StatelessWidget {
//   const UpdateCheckerApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Checking for Updates...',
//       home: const NewM(),
//       theme: ThemeData(
//         primaryColor: Color(0xFF1E90FF), // Royal Blue
//         hintColor: Color(0xFFFF6B6B), // Soft Light Gray
//         scaffoldBackgroundColor: Color(0xFFF4F5F7),
//         cardColor: Color(0xFFFFFFFF), // Pure White
//         textTheme: TextTheme(
//           displayLarge: TextStyle(color: Color(0xFF2D2D2D)), // Dark Gray
//           bodyLarge: TextStyle(color: Color(0xFF6B6B6B)), // Secondary Gray
//         ),
//         buttonTheme: ButtonThemeData(
//           buttonColor: Color(0xFF1E90FF), // Primary button color
//           textTheme: ButtonTextTheme.primary,
//         ),
//         useMaterial3: true,
//       ),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class UpdateChecker extends StatefulWidget {
//   const UpdateChecker({super.key});

//   @override
//   _UpdateCheckerState createState() => _UpdateCheckerState();
// }

// class _UpdateCheckerState extends State<UpdateChecker> {
//   @override
//   void initState() {
//     super.initState();
//     _checkForAppUpdate();
//   }

//   Future<void> _checkForAppUpdate() async {
//     // Fetch JSON from an online source
//     const url = 'https://aicnc.netlify.app/app_version_info.json'; // Replace with your actual URL
//     try {
//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         final packageInfo = await PackageInfo.fromPlatform();
//         String currentVersionName = packageInfo.version;
//         int currentVersionNumber = int.parse(packageInfo.buildNumber);

//         Map<String, dynamic> versionInfo = jsonDecode(response.body);
//         String requiredVersionName = versionInfo['versionName'];
//         int requiredVersionNumber = versionInfo['versionNumber'];

//         int serverDown = versionInfo['ServerDown'];
//         int appUpdate = versionInfo['appUpdateDown'];

//         if (_isVersionOutdated(currentVersionName, requiredVersionName,
//             currentVersionNumber, requiredVersionNumber)) {
//           _showUpdateDialog(requiredVersionName);
//         } else if (serverDown == 0) {
//           _showServerDownDialog();
//         } else if (appUpdate == 0) {
//           _showServerDownForUpdateDialog();
//         } else {
//           _startApp();
//         }
//       } else {
//         _showErrorDialog('Failed to fetch version info. Status code: ${response.statusCode}');
//       }
//     } catch (error) {
//       _showErrorDialog('Error fetching version info: $error');
//     }
//   }

//   bool _isVersionOutdated(String currentVersionName, String requiredVersionName,
//       int currentVersionNumber, int requiredVersionNumber) {
//     return currentVersionName != requiredVersionName ||
//         currentVersionNumber < requiredVersionNumber;
//   }

//   void _showUpdateDialog(String requiredVersionNumber) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return WillPopScope(
//           onWillPop: () async => false,
//           child: AlertDialog(
//             title: const Text('Update Required'),
//             content: Text(
//                 'A new version of the app ($requiredVersionNumber) is available. Please update to continue.'),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('Update Now'),
//                 onPressed: () {
//                   _launchAppStore();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showServerDownDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return WillPopScope(
//           onWillPop: () async => false,
//           child: AlertDialog(
//             title: const Text('Maintenance Down'),
//             content: const Text(
//                 'Server down due to regular maintenance. Please be patient.'),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('Stay Updated'),
//                 onPressed: () {
//                   _stayUpdateWithUS();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showServerDownForUpdateDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return WillPopScope(
//           onWillPop: () async => false,
//           child: AlertDialog(
//             title: const Text('New Features on the way'),
//             content: const Text(
//                 'We are updating our server and application. Please be patient.'),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('Stay Updated'),
//                 onPressed: () {
//                   _stayUpdateWithUS();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showErrorDialog(String errorMessage) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Error'),
//           content: Text('Error fetching app version info: $errorMessage'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _launchAppStore() async {
//     const url = 'https://play.google.com/store/apps/details?id=anc.nocorps.xyz';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       print('Could not launch $url');
//     }
//   }

//   Future<void> _stayUpdateWithUS() async {
//     const url = 'https://x.com/nocorps_dev';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       print('Could not launch $url');
//     }
//   }

//   void _startApp() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const NewM()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: GoogleColorChangingProgressBar(),
//       ),
//     );
//   }
// }

// class NewM extends StatelessWidget {
//   static final GlobalKey<NavigatorState> navigatorKey =
//       GlobalKey<NavigatorState>();

//   const NewM({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'AirDrops - NC',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       navigatorKey: navigatorKey,
//       home: const SplashScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
