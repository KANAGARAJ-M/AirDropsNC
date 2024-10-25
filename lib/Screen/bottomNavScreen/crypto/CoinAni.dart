import 'package:air_drops/colors/UiColors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class CoinAnimationScreen extends StatefulWidget {
  const CoinAnimationScreen({super.key});

  @override
  _CoinAnimationScreenState createState() => _CoinAnimationScreenState();
}

class _CoinAnimationScreenState extends State<CoinAnimationScreen> {
  bool _isAnimating = false;
  int _counter = 0; // Total taps
  int _dailyTaps = 0; // Taps for the current day
  final int _dailyLimit = 200; // Daily tap limit
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  @override
  void initState() {
    super.initState();
    _loadCounter(); // Load counter and daily taps when screen is initialized
  }

  // Method to load counter and daily taps from Firestore
  Future<void> _loadCounter() async {
    User? user = _auth.currentUser; // Get the current user
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get(); // Get user document
      if (doc.exists) {
        setState(() {
          _counter = doc['counter'] ?? 0; // Set total taps from Firestore
          _dailyTaps = doc['dailyTaps'] ?? 0; // Set daily taps from Firestore
          String lastTapDate = doc['lastTapDate'] ?? ''; // Get last tap date
          String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Get today's date

          // Reset daily taps if the last tap was not today
          if (lastTapDate != todayDate) {
            _dailyTaps = 0; // Reset daily taps
            _updateDailyTaps(0, todayDate); // Update Firestore with reset
          }
        });
      } else {
        // If the document doesn't exist, create it with initial values
        await _firestore.collection('users').doc(user.uid).set({
          'counter': 0,
          'dailyTaps': 0,
          'lastTapDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        });
      }
    }
  }

  // Method to update counter and daily taps in Firestore
  Future<void> _updateCounter() async {
    User? user = _auth.currentUser; // Get the current user
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'counter': _counter, // Save total taps to Firestore
      }, SetOptions(merge: true)); // Merge to avoid overwriting other fields
    }
  }

  // Method to update daily taps and last tap date
  Future<void> _updateDailyTaps(int dailyTaps, String lastTapDate) async {
    User? user = _auth.currentUser; // Get the current user
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'dailyTaps': dailyTaps, // Save daily taps to Firestore
        'lastTapDate': lastTapDate, // Save last tap date
      }, SetOptions(merge: true)); // Merge to avoid overwriting other fields
    }
  }

  void _toggleAnimation() {
    if (_dailyTaps < _dailyLimit) { // Check if the daily tap limit has been reached
      setState(() {
        _isAnimating = !_isAnimating;
        _counter++; // Increment the total counter on each tap
        _dailyTaps++; // Increment the daily counter
      });
      _updateCounter(); // Update total counter in Firestore
      _updateDailyTaps(_dailyTaps, DateFormat('yyyy-MM-dd').format(DateTime.now())); // Update daily taps in Firestore
    } else {
      _showLimitReachedDialog(); // Show alert dialog when daily limit is reached
    }
  }

  // Method to show an alert dialog when daily limit is reached
  void _showLimitReachedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limit Reached'),
          content: Text(
            'You have reached your daily tap limit of $_dailyLimit.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Uicolor.body,
      appBar: AppBar(
        title: const Text('Ancient Ice Crystal',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w900),),
        backgroundColor: Uicolor.appBar,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Text("Season 1"),
            Text(
              'AIC Earned: $_counter', // Display total taps
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: _toggleAnimation, // Trigger animation and counter increment on tap
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: _isAnimating ? 250 : 179, // Change size on animation
                height: _isAnimating ? 250 : 179,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal[800],
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '❄️',
                    style: TextStyle(
                      fontSize: _isAnimating ? 100 : 69, // Change size of "ANC"
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              'Daily AIC: $_dailyTaps / $_dailyLimit', // Display daily taps and limit
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}











// import 'package:air_drops/database/db_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart'; // Import for date formatting


// class CoinAnimationScreen extends StatefulWidget {
//   @override
//   _CoinAnimationScreenState createState() => _CoinAnimationScreenState();
// }

// class _CoinAnimationScreenState extends State<CoinAnimationScreen> {
//   bool _isAnimating = false;
//   int _counter = 0; // Total taps
//   int _dailyTaps = 0; // Taps for the current day
//   final int _dailyLimit = 200; // Daily tap limit
//   final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
//   final DBHelper _dbHelper = DBHelper(); // Local database helper

//   @override
//   void initState() {
//     super.initState();
//     _loadCounter(); // Load counter and daily taps when screen is initialized
//   }

//   // Method to load counter and daily taps from Firestore and LocalDB
//   Future<void> _loadCounter() async {
//     // Load from local DB first
//     final localData = await _dbHelper.getData();
//     if (localData != null) {
//       setState(() {
//         _counter = localData['counter'] ?? 0;
//         _dailyTaps = localData['dailyTaps'] ?? 0;
//       });
//     }

//     User? user = _auth.currentUser; // Get the current user
//     if (user != null) {
//       DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get(); // Get user document
//       if (doc.exists) {
//         setState(() {
//           _counter = doc['counter'] ?? _counter; // Set total taps from Firestore
//           _dailyTaps = doc['dailyTaps'] ?? _dailyTaps; // Set daily taps from Firestore
//           String lastTapDate = doc['lastTapDate'] ?? ''; // Get last tap date
//           String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Get today's date

//           // Reset daily taps if the last tap was not today
//           if (lastTapDate != todayDate) {
//             _dailyTaps = 0; // Reset daily taps
//             _updateDailyTaps(0, todayDate); // Update Firestore with reset
//             _dbHelper.updateData(_counter, 0); // Update local DB with reset
//           }
//         });
//       } else {
//         // If the document doesn't exist, create it with initial values
//         await _firestore.collection('users').doc(user.uid).set({
//           'counter': _counter,
//           'dailyTaps': _dailyTaps,
//           'lastTapDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
//         });
//       }
//     }
//   }

//   // Method to update counter and daily taps in Firestore and LocalDB
//   Future<void> _updateCounter() async {
//     User? user = _auth.currentUser; // Get the current user
//     if (user != null) {
//       await _firestore.collection('users').doc(user.uid).set({
//         'counter': _counter, // Save total taps to Firestore
//       }, SetOptions(merge: true)); // Merge to avoid overwriting other fields
//       // Save to local DB
//       _dbHelper.updateData(_counter, _dailyTaps);
//     }
//   }

//   // Method to update daily taps and last tap date
//   Future<void> _updateDailyTaps(int dailyTaps, String lastTapDate) async {
//     User? user = _auth.currentUser; // Get the current user
//     if (user != null) {
//       await _firestore.collection('users').doc(user.uid).set({
//         'dailyTaps': dailyTaps, // Save daily taps to Firestore
//         'lastTapDate': lastTapDate, // Save last tap date
//       }, SetOptions(merge: true)); // Merge to avoid overwriting other fields
//       // Save to local DB
//       _dbHelper.updateData(_counter, dailyTaps);
//     }
//   }

//   void _toggleAnimation() {
//     if (_dailyTaps < _dailyLimit) { // Check if the daily tap limit has been reached
//       setState(() {
//         _isAnimating = !_isAnimating;
//         _counter++; // Increment the total counter on each tap
//         _dailyTaps++; // Increment the daily counter
//       });
//       _updateCounter(); // Update total counter in Firestore and LocalDB
//       _updateDailyTaps(_dailyTaps, DateFormat('yyyy-MM-dd').format(DateTime.now())); // Update daily taps in Firestore and LocalDB
//     } else {
//       _showLimitReachedDialog(); // Show alert dialog when daily limit is reached
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[400],
//       appBar: AppBar(
//         title: Text('Ancient Ice Crystal', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
//         backgroundColor: Colors.blue[400],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Text(
//               'AIC Earned: $_counter', // Display total taps
//               style: TextStyle(
//                 fontSize: 24,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             GestureDetector(
//               onTap: _toggleAnimation, // Trigger animation and counter increment on tap
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 120),
//                 width: _isAnimating ? 250 : 179, // Change size on animation
//                 height: _isAnimating ? 250 : 179,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.lightBlueAccent,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 20,
//                       offset: Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Text(
//                     '❄️',
//                     style: TextStyle(
//                       fontSize: _isAnimating ? 100 : 69, // Change size of "ANC"
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Text(
//               'Daily AIC: $_dailyTaps / $_dailyLimit', // Display daily taps and limit
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showLimitReachedDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Daily Limit Reached'),
//           content: Text('You have reached your daily AIC limit for today.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }



















// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'package:connectivity_plus/connectivity_plus.dart'; // Import connectivity_plus
// import 'dart:io';

// import '../../../database/db_helper.dart'; // Import for closing the app

// class CoinAnimationScreen extends StatefulWidget {
//   @override
//   _CoinAnimationScreenState createState() => _CoinAnimationScreenState();
// }

// class _CoinAnimationScreenState extends State<CoinAnimationScreen> {
//   bool _isAnimating = false;
//   int _counter = 0; // Total taps
//   int _dailyTaps = 0; // Taps for the current day
//   final int _dailyLimit = 200; // Daily tap limit
//   final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
//   final DBHelper _dbHelper = DBHelper(); // Local database helper
//   ConnectivityResult? _connectionStatus; // Store connection status

//   @override
//   void initState() {
//     super.initState();
//     _loadCounter(); // Load counter and daily taps when screen is initialized
//     _checkNetworkStatus(); // Check network speed when screen is initialized
//   }

//   // Method to load counter and daily taps from Firestore and LocalDB
//   Future<void> _loadCounter() async {
//     // Load from local DB first
//     final localData = await _dbHelper.getData();
//     if (localData != null) {
//       setState(() {
//         _counter = localData['counter'] ?? 0;
//         _dailyTaps = localData['dailyTaps'] ?? 0;
//       });
//     }

//     User? user = _auth.currentUser; // Get the current user
//     if (user != null) {
//       DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get(); // Get user document
//       if (doc.exists) {
//         setState(() {
//           _counter = doc['counter'] ?? _counter; // Set total taps from Firestore
//           _dailyTaps = doc['dailyTaps'] ?? _dailyTaps; // Set daily taps from Firestore
//           String lastTapDate = doc['lastTapDate'] ?? ''; // Get last tap date
//           String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Get today's date

//           // Reset daily taps if the last tap was not today
//           if (lastTapDate != todayDate) {
//             _dailyTaps = 0; // Reset daily taps
//             _updateDailyTaps(0, todayDate); // Update Firestore with reset
//             _dbHelper.updateData(_counter, 0); // Update local DB with reset
//           }
//         });
//       } else {
//         // If the document doesn't exist, create it with initial values
//         await _firestore.collection('users').doc(user.uid).set({
//           'counter': _counter,
//           'dailyTaps': _dailyTaps,
//           'lastTapDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
//         });
//       }
//     }
//   }

//   // Method to update counter and daily taps in Firestore and LocalDB
//   Future<void> _updateCounter() async {
//     User? user = _auth.currentUser; // Get the current user
//     if (user != null) {
//       await _firestore.collection('users').doc(user.uid).set({
//         'counter': _counter, // Save total taps to Firestore
//       }, SetOptions(merge: true)); // Merge to avoid overwriting other fields
//       // Save to local DB
//       _dbHelper.updateData(_counter, _dailyTaps);
//     }
//   }

//   // Method to update daily taps and last tap date
//   Future<void> _updateDailyTaps(int dailyTaps, String lastTapDate) async {
//     User? user = _auth.currentUser; // Get the current user
//     if (user != null) {
//       await _firestore.collection('users').doc(user.uid).set({
//         'dailyTaps': dailyTaps, // Save daily taps to Firestore
//         'lastTapDate': lastTapDate, // Save last tap date
//       }, SetOptions(merge: true)); // Merge to avoid overwriting other fields
//       // Save to local DB
//       _dbHelper.updateData(_counter, dailyTaps);
//     }
//   }

//   // Method to check network status and handle slow connection
//   Future<void> _checkNetworkStatus() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
//       try {
//         // Ping Google to check network speed
//         final result = await InternetAddress.lookup('google.com');
//         if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//           setState(() {
//             _connectionStatus = connectivityResult as ConnectivityResult?;
//           });
//         }
//       } on SocketException catch (_) {
//         _showSlowNetworkDialog();
//       }
//     } else {
//       _showSlowNetworkDialog();
//     }
//   }

//   // Show dialog if the network is slow and close the app
//   void _showSlowNetworkDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // Prevent closing the dialog by tapping outside
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Slow Network Detected'),
//           content: Text('Your network connection is too slow. The app will now close.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 exit(0); // Close the app
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _toggleAnimation() {
//     if (_dailyTaps < _dailyLimit) { // Check if the daily tap limit has been reached
//       setState(() {
//         _isAnimating = !_isAnimating;
//         _counter++; // Increment the total counter on each tap
//         _dailyTaps++; // Increment the daily counter
//       });
//       _updateCounter(); // Update total counter in Firestore and LocalDB
//       _updateDailyTaps(_dailyTaps, DateFormat('yyyy-MM-dd').format(DateTime.now())); // Update daily taps in Firestore and LocalDB
//     } else {
//       _showLimitReachedDialog(); // Show alert dialog when daily limit is reached
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[400],
//       appBar: AppBar(
//         title: Text('Ancient Ice Crystal', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
//         backgroundColor: Colors.blue[400],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Text(
//               'AIC Earned: $_counter', // Display total taps
//               style: TextStyle(
//                 fontSize: 24,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             GestureDetector(
//               onTap: _toggleAnimation, // Trigger animation and counter increment on tap
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 120),
//                 width: _isAnimating ? 250 : 179, // Change size on animation
//                 height: _isAnimating ? 250 : 179,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.lightBlueAccent,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 20,
//                       offset: Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Text(
//                     '❄️',
//                     style: TextStyle(
//                       fontSize: _isAnimating ? 100 : 69, // Change size of "ANC"
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Text(
//               'Daily AIC: $_dailyTaps / $_dailyLimit', // Display daily taps and limit
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showLimitReachedDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Daily Limit Reached'),
//           content: Text('You have reached your daily AIC limit for today.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }














// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import '../../../database/db_helper.dart';
// import 'package:connectivity_plus/connectivity_plus.dart'; // Import connectivity_plus
// import 'dart:io'; // Import for closing the app

// class CoinAnimationScreen extends StatefulWidget {
//   @override
//   _CoinAnimationScreenState createState() => _CoinAnimationScreenState();
// }

// class _CoinAnimationScreenState extends State<CoinAnimationScreen> {
//   bool _isAnimating = false;
//   int _counter = 0; // Total taps
//   int _dailyTaps = 0; // Taps for the current day
//   final int _dailyLimit = 200; // Daily tap limit
//   final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
//   final DBHelper _dbHelper = DBHelper(); // Local database helper
//   ConnectivityResult? _connectionStatus; // Store connection status
//   String _networkSignalStrength = 'Unknown'; // Track signal strength

//   @override
//   void initState() {
//     super.initState();
//     _loadCounter(); // Load counter and daily taps when screen is initialized
//     _checkNetworkStatus(); // Check network speed when screen is initialized
//   }

//   // Method to load counter and daily taps from Firestore and LocalDB
//   Future<void> _loadCounter() async {
//     // Load from local DB first
//     final localData = await _dbHelper.getData();
//     if (localData != null) {
//       setState(() {
//         _counter = localData['counter'] ?? 0;
//         _dailyTaps = localData['dailyTaps'] ?? 0;
//       });
//     }

//     User? user = _auth.currentUser; // Get the current user
//     if (user != null) {
//       DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get(); // Get user document
//       if (doc.exists) {
//         setState(() {
//           _counter = doc['counter'] ?? _counter; // Set total taps from Firestore
//           _dailyTaps = doc['dailyTaps'] ?? _dailyTaps; // Set daily taps from Firestore
//           String lastTapDate = doc['lastTapDate'] ?? ''; // Get last tap date
//           String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Get today's date

//           // Reset daily taps if the last tap was not today
//           if (lastTapDate != todayDate) {
//             _dailyTaps = 0; // Reset daily taps
//             _updateDailyTaps(0, todayDate); // Update Firestore with reset
//             _dbHelper.updateData(_counter, 0); // Update local DB with reset
//           }
//         });
//       } else {
//         // If the document doesn't exist, create it with initial values
//         await _firestore.collection('users').doc(user.uid).set({
//           'counter': _counter,
//           'dailyTaps': _dailyTaps,
//           'lastTapDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
//         });
//       }
//     }
//   }

//   // Method to update counter and daily taps in Firestore and LocalDB
//   Future<void> _updateCounter() async {
//     User? user = _auth.currentUser; // Get the current user
//     if (user != null) {
//       await _firestore.collection('users').doc(user.uid).set({
//         'counter': _counter, // Save total taps to Firestore
//       }, SetOptions(merge: true)); // Merge to avoid overwriting other fields
//       // Save to local DB
//       _dbHelper.updateData(_counter, _dailyTaps);
//     }
//   }

//   // Method to update daily taps and last tap date
//   Future<void> _updateDailyTaps(int dailyTaps, String lastTapDate) async {
//     User? user = _auth.currentUser; // Get the current user
//     if (user != null) {
//       await _firestore.collection('users').doc(user.uid).set({
//         'dailyTaps': dailyTaps, // Save daily taps to Firestore
//         'lastTapDate': lastTapDate, // Save last tap date
//       }, SetOptions(merge: true)); // Merge to avoid overwriting other fields
//       // Save to local DB
//       _dbHelper.updateData(_counter, dailyTaps);
//     }
//   }

//   // Method to check network status and handle slow connection
//   Future<void> _checkNetworkStatus() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
//       try {
//         // Ping Google to check network speed
//         final result = await InternetAddress.lookup('google.com');
//         if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//           setState(() {
//             _connectionStatus = connectivityResult as ConnectivityResult?;
//             _networkSignalStrength = connectivityResult == ConnectivityResult.mobile ? "Mobile Signal" : "WiFi Signal";
//           });
//         }
//       } on SocketException catch (_) {
//         _showSlowNetworkDialog();
//       }
//     } else {
//       setState(() {
//         _networkSignalStrength = 'No Connection';
//       });
//       _showSlowNetworkDialog();
//     }
//   }

//   // Show dialog if the network is slow and close the app
//   void _showSlowNetworkDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // Prevent closing the dialog by tapping outside
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Slow Network Detected'),
//           content: Text('Your network connection is too slow. Please check your connection and retry.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 _checkNetworkStatus(); // Retry network check
//               },
//               child: Text('Retry'),
//             ),
//             TextButton(
//               onPressed: () {
//                 exit(0); // Close the app
//               },
//               child: Text('Close App'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _toggleAnimation() {
//     if (_dailyTaps < _dailyLimit) { // Check if the daily tap limit has been reached
//       setState(() {
//         _isAnimating = !_isAnimating;
//         _counter++; // Increment the total counter on each tap
//         _dailyTaps++; // Increment the daily counter
//       });
//       _updateCounter(); // Update total counter in Firestore and LocalDB
//       _updateDailyTaps(_dailyTaps, DateFormat('yyyy-MM-dd').format(DateTime.now())); // Update daily taps in Firestore and LocalDB
//     } else {
//       _showLimitReachedDialog(); // Show alert dialog when daily limit is reached
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[400],
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('Ancient Ice Crystal', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
//             Row(
//               children: [
//                 Icon(
//                   _connectionStatus == ConnectivityResult.mobile
//                       ? Icons.signal_cellular_alt
//                       : _connectionStatus == ConnectivityResult.wifi
//                           ? Icons.wifi
//                           : Icons.signal_cellular_off, // Display signal strength based on connection type
//                   color: Colors.white,
//                 ),
//                 SizedBox(width: 5),
//                 Text(
//                   _networkSignalStrength, // Display signal type
//                   style: TextStyle(color: Colors.white, fontSize: 14),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         backgroundColor: Colors.blue[400],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Text(
//               'AIC Earned: $_counter', // Display total taps
//               style: TextStyle(
//                 fontSize: 24,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             GestureDetector(
//               onTap: _toggleAnimation, // Trigger animation and counter increment on tap
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 120),
//                 width: _isAnimating ? 250 : 179, // Change size on animation
//                 height: _isAnimating ? 250 : 179,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.lightBlueAccent,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 20,
//                       offset: Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Text(
//                     '❄️',
//                     style: TextStyle(
//                       fontSize: _isAnimating ? 100 : 69, // Change size of "ANC"
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Text(
//               'Daily Limit: $_dailyTaps / $_dailyLimit', // Display daily taps
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Show dialog when daily limit is reached
//   void _showLimitReachedDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Daily Limit Reached'),
//           content: Text('You have reached your daily AIC limit for today.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }


















// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import '../../../database/db_helper.dart';
// // import 'db_helper.dart';
// import 'package:connectivity_plus/connectivity_plus.dart'; // Import connectivity_plus
// import 'dart:io'; // Import for closing the app
// import 'package:http/http.dart' as http; // Import for making network requests
// import 'dart:async';

// class CoinAnimationScreen extends StatefulWidget {
//   @override
//   _CoinAnimationScreenState createState() => _CoinAnimationScreenState();
// }

// class _CoinAnimationScreenState extends State<CoinAnimationScreen> {
//   bool _isAnimating = false;
//   int _counter = 0; // Total taps
//   int _dailyTaps = 0; // Taps for the current day
//   final int _dailyLimit = 200; // Daily tap limit
//   final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
//   final DBHelper _dbHelper = DBHelper(); // Local database helper
//   ConnectivityResult? _connectionStatus; // Store connection status
//   String _networkSignalStrength = 'Unknown'; // Track signal strength

//   @override
//   void initState() {
//     super.initState();
//     _loadCounter(); // Load counter and daily taps when screen is initialized
//     _checkNetworkStatus(); // Check network speed when screen is initialized
//   }

//   // Method to load counter and daily taps from Firestore and LocalDB
//   Future<void> _loadCounter() async {
//     // Load from local DB first
//     final localData = await _dbHelper.getData();
//     if (localData != null) {
//       setState(() {
//         _counter = localData['counter'] ?? 0;
//         _dailyTaps = localData['dailyTaps'] ?? 0;
//       });
//     }

//     User? user = _auth.currentUser; // Get the current user
//     if (user != null) {
//       DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get(); // Get user document
//       if (doc.exists) {
//         setState(() {
//           _counter = doc['counter'] ?? _counter; // Set total taps from Firestore
//           _dailyTaps = doc['dailyTaps'] ?? _dailyTaps; // Set daily taps from Firestore
//           String lastTapDate = doc['lastTapDate'] ?? ''; // Get last tap date
//           String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Get today's date

//           // Reset daily taps if the last tap was not today
//           if (lastTapDate != todayDate) {
//             _dailyTaps = 0; // Reset daily taps
//             _updateDailyTaps(0, todayDate); // Update Firestore with reset
//             _dbHelper.updateData(_counter, 0); // Update local DB with reset
//           }
//         });
//       } else {
//         // If the document doesn't exist, create it with initial values
//         await _firestore.collection('users').doc(user.uid).set({
//           'counter': _counter,
//           'dailyTaps': _dailyTaps,
//           'lastTapDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
//         });
//       }
//     }
//   }

//   // Method to update counter and daily taps in Firestore and LocalDB
//   Future<void> _updateCounter() async {
//     User? user = _auth.currentUser; // Get the current user
//     if (user != null) {
//       await _firestore.collection('users').doc(user.uid).set({
//         'counter': _counter, // Save total taps to Firestore
//       }, SetOptions(merge: true)); // Merge to avoid overwriting other fields
//       // Save to local DB
//       _dbHelper.updateData(_counter, _dailyTaps);
//     }
//   }

//   // Method to update daily taps and last tap date
//   Future<void> _updateDailyTaps(int dailyTaps, String lastTapDate) async {
//     User? user = _auth.currentUser; // Get the current user
//     if (user != null) {
//       await _firestore.collection('users').doc(user.uid).set({
//         'dailyTaps': dailyTaps, // Save daily taps to Firestore
//         'lastTapDate': lastTapDate, // Save last tap date
//       }, SetOptions(merge: true)); // Merge to avoid overwriting other fields
//       // Save to local DB
//       _dbHelper.updateData(_counter, dailyTaps);
//     }
//   }

//   // Method to check network status and handle slow connection by testing 500KB transmission
//   Future<void> _checkNetworkStatus() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
//       try {
//         // Test network speed by attempting to download 500KB
//         bool isSlowNetwork = await _testNetworkSpeed();
//         if (isSlowNetwork) {
//           _showSlowNetworkDialog();
//         } else {
//           setState(() {
//             _connectionStatus = connectivityResult as ConnectivityResult?;
//             _networkSignalStrength = connectivityResult == ConnectivityResult.mobile ? "Mobile Signal" : "WiFi Signal";
//           });
//         }
//       } catch (_) {
//         _showSlowNetworkDialog();
//       }
//     } else {
//       setState(() {
//         _networkSignalStrength = 'No Connection';
//       });
//       _showSlowNetworkDialog();
//     }
//   }

//   // Method to test network speed by downloading a 500KB file
//   Future<bool> _testNetworkSpeed() async {
//     try {
//       final startTime = DateTime.now();
//       // Replace with a reliable URL of a file or image of at least 500KB in size
//       final response = await http.get(Uri.parse('https://speed.hetzner.de/512k.bin'));

//       if (response.statusCode == 200 && response.contentLength != null) {
//         final endTime = DateTime.now();
//         final elapsedMilliseconds = endTime.difference(startTime).inMilliseconds;

//         // If the download of 500KB takes longer than 2 seconds, consider it slow
//         if (elapsedMilliseconds > 2000) {
//           return true; // Slow network
//         } else {
//           return false; // Network is fine
//         }
//       } else {
//         return true; // Consider network slow if the response is invalid
//       }
//     } catch (e) {
//       return true; // Return true for slow network if an error occurs
//     }
//   }

//   // Show dialog if the network is slow
//   void _showSlowNetworkDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // Prevent closing the dialog by tapping outside
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Slow Network Detected'),
//           content: Text('Your network connection is too slow. Please check your connection and retry.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 _checkNetworkStatus(); // Retry network check
//               },
//               child: Text('Retry'),
//             ),
//             TextButton(
//               onPressed: () {
//                 exit(0); // Close the app
//               },
//               child: Text('Close App'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _toggleAnimation() {
//     if (_dailyTaps < _dailyLimit) { // Check if the daily tap limit has been reached
//       setState(() {
//         _isAnimating = !_isAnimating;
//         _counter++; // Increment the total counter on each tap
//         _dailyTaps++; // Increment the daily counter
//       });
//       _updateCounter(); // Update total counter in Firestore and LocalDB
//       _updateDailyTaps(_dailyTaps, DateFormat('yyyy-MM-dd').format(DateTime.now())); // Update daily taps in Firestore and LocalDB
//     } else {
//       _showLimitReachedDialog(); // Show alert dialog when daily limit is reached
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[400],
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('Ancient Ice Crystal', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
//             Row(
//               children: [
//                 Icon(
//                   _connectionStatus == ConnectivityResult.mobile
//                       ? Icons.signal_cellular_alt
//                       : _connectionStatus == ConnectivityResult.wifi
//                           ? Icons.wifi
//                           : Icons.signal_cellular_off, // Display signal strength based on connection type
//                   color: Colors.white,
//                 ),
//                 SizedBox(width: 5),
//                 Text(
//                   _networkSignalStrength, // Display signal type
//                   style: TextStyle(color: Colors.white, fontSize: 14),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         backgroundColor: Colors.blue[400],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             GestureDetector(
//               onTap: _toggleAnimation,
//               child: Container(
//                 width: 150,
//                 height: 150,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white,
//                 ),
//                 child: Center(
//                   child: AnimatedContainer(
//                     duration: Duration(milliseconds: 300),
//                     width: _isAnimating ? 100 : 80,
//                     height: _isAnimating ? 100 : 80,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.yellow[700],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Text(
//               'Daily Limit: $_dailyTaps / $_dailyLimit', // Display daily taps
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Show dialog when daily limit is reached
//   void _showLimitReachedDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Daily Limit Reached'),
//           content: Text('You have reached your daily AIC limit for today.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
