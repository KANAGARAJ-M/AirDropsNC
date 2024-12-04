import 'dart:convert';
import 'package:air_drops/phase1/Screen/Splash.dart';
import 'package:air_drops/phase1/customs/GoogleProgressBarC.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  _PermissionsHandler();
  await Supabase.initialize(
    url: 'https://vdauwgurmubcnnqhtjnk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZkYXV3Z3VybXViY25ucWh0am5rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjk5NDI2NzMsImV4cCI6MjA0NTUxODY3M30._Ow86Tn28BmH6qbxs3vwNlWhDmZS1VRGvDsw4UQcB5Q',
  );
  runApp(const UpdateCheckerAppScreen());
}


Future<void> _PermissionsHandler() async {
  var noti_status = await Permission.notification.status;
  var location_status = await Permission.location.status; 
  if (noti_status.isDenied && location_status.isDenied) {
    noti_status = await Permission.notification.request();
    if (noti_status.isDenied) {
      // Handle the denied state
    }
  } else {}
}


class UpdateCheckerAppScreen extends StatelessWidget {
  const UpdateCheckerAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Checking for Updates...',
      home: UpdateCheckerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class UpdateCheckerScreen extends StatefulWidget {
  const UpdateCheckerScreen({super.key});

  @override
  State<UpdateCheckerScreen> createState() => _UpdateCheckerScreenState();
}

class _UpdateCheckerScreenState extends State<UpdateCheckerScreen> {
  @override
  void initState() {
    super.initState();
    _checkForAppUpdate();
  }

  Future<void> _checkForAppUpdate() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: Duration.zero));
      await remoteConfig.fetchAndActivate();

      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersionName = packageInfo.version;
      int currentVersionNumber = int.parse(packageInfo.buildNumber);

      String versionInfoJson = remoteConfig.getString('app_version_info');
      Map<String, dynamic> versionInfo = jsonDecode(versionInfoJson);

      String requiredVersionName = versionInfo['versionName'];
      int requiredVersionNumber = versionInfo['versionNumber'];

      int serverDown = remoteConfig.getInt('ServerDown');
      int appUpdate = remoteConfig.getInt('appupdatedown');

      if (_isVersionOutdated(currentVersionName, requiredVersionName,
          currentVersionNumber, requiredVersionNumber)) {
        _showUpdateDialog(requiredVersionName);
      } else if (serverDown == 1) {
        _ShowServerDownFunction(serverDown);
      } else if (appUpdate == 1) {
        _ShowServerDownForUpdate(appUpdate);
      } else {
        _startApp();
      }
    } catch (e) {
      _showErrorDialog(e.toString());
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
              child: AlertDialog(
                  title: const Text('Update Available'),
                  content: const Text(
                      'A new version of the app is available. Please update to the latest version.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        _launchAppStore();
                      },
                      child: Text('Update Now'),
                    ),
                  ]),
              onWillPop: () async => false);
        });
  }

  void _ShowServerDownFunction(int f) {
    showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
              title: const Text("Maintenance Down"),
              content: const Text(
                  "The server is currently down for maintenance. Please try again later."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _stayUpdateWithUS();
                  },
                  child: Text('Stay Updated With Us'),
                ),
              ]),
        );
      },
    );
  }

  void _ShowServerDownForUpdate(int f) {
    showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
              title: const Text("New Features on the Way !"),
              content: const Text(
                  "We are working on some new features. Please stay updated with us."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _stayUpdateWithUS();
                  },
                  child: Text('Stay Updated With Us'),
                ),
              ]),
        );
      },
    );
  }

  Future<void> _launchAppStore() async {
    const String url =
        'https://play.google.com/store/apps/details?id=anc.nocorps.xyz';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch $url");
    }
  }

  Future<void> _stayUpdateWithUS() async {
    const String url = 'https://x.com/nocorps_dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch $url");
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext connect) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error fetching  update information: $errorMessage'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK')),
            ],
          );
        });
  }

  void _startApp() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext content) => NewM()));
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
      title: 'AIC Coin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}














// Copyright [2023] [KANAGARAJ M]

//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at

//        http://www.apache.org/licenses/LICENSE-2.0

//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.


// import 'package:air_drops/phase1/main.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// // import 'package:supabase_flutter/supabase_flutter.dart';
// ///PHASE 2
// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp();
// //   await Supabase.initialize(
// //     url: 'https://vdauwgurmubcnnqhtjnk.supabase.co',
// //     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZkYXV3Z3VybXViY25ucWh0am5rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjk5NDI2NzMsImV4cCI6MjA0NTUxODY3M30._Ow86Tn28BmH6qbxs3vwNlWhDmZS1VRGvDsw4UQcB5Q',
// //   );
// //   runApp(MyApp());
// // }


// ///PHASE !
// Future<void> main() async {
  
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   MobileAds.instance.initialize();
//   _PermissionsHandler();
//   await Supabase.initialize(
//     url: 'https://vdauwgurmubcnnqhtjnk.supabase.co',
//     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZkYXV3Z3VybXViY25ucWh0am5rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjk5NDI2NzMsImV4cCI6MjA0NTUxODY3M30._Ow86Tn28BmH6qbxs3vwNlWhDmZS1VRGvDsw4UQcB5Q',
//   );
//   runApp(const UpdateCheckerApp());
// }

// Future<void> _PermissionsHandler() async {
//   var noti_status = await Permission.notification.status;
//   var location_status = await Permission.location.status; 
//   if (noti_status.isDenied && location_status.isDenied) {
//     noti_status = await Permission.notification.request();
//     if (noti_status.isDenied) {
//       // Handle the denied state
//     }
//   } else {}
// }