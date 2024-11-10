// import 'package:air_drops/phase1/colors/UiColors.dart';
// import 'package:air_drops/phase1/policy/PrivacyPolicyPage.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart'; // Import for date formatting

// class CoinAnimationScreen extends StatefulWidget {
//   const CoinAnimationScreen({super.key});

//   @override
//   _CoinAnimationScreenState createState() => _CoinAnimationScreenState();
// }

// class _CoinAnimationScreenState extends State<CoinAnimationScreen> {
//   bool _isAnimating = false;
//   int _counter = 0; // Total taps
//   int _dailyTaps = 0; // Taps for the current day
//   final int _dailyLimit = 200; // Daily tap limit
//   final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
//   final FirebaseFirestore _firestore =
//       FirebaseFirestore.instance; // Firestore instance

//   @override
//   void initState() {
//     super.initState();
//     _loadCounter(); // Load counter and daily taps when screen is initialized
//   }

//   // Method to load counter and daily taps from Firestore
//   Future<void> _loadCounter() async {
//     User? user = _auth.currentUser; // Get the current user
//     if (user != null) {
//       DocumentSnapshot doc = await _firestore
//           .collection('users')
//           .doc(user.uid)
//           .get(); // Get user document
//       if (doc.exists) {
//         setState(() {
//           _counter = doc['counter'] ?? 0; // Set total taps from Firestore
//           _dailyTaps = doc['dailyTaps'] ?? 0; // Set daily taps from Firestore
//           String lastTapDate = doc['lastTapDate'] ?? ''; // Get last tap date
//           String todayDate = DateFormat('yyyy-MM-dd')
//               .format(DateTime.now()); // Get today's date

//           // Reset daily taps if the last tap was not today
//           if (lastTapDate != todayDate) {
//             _dailyTaps = 0; // Reset daily taps
//             _updateDailyTaps(0, todayDate); // Update Firestore with reset
//           }
//         });
//       } else {
//         // If the document doesn't exist, create it with initial values
//         await _firestore.collection('users').doc(user.uid).set({
//           'counter': 0,
//           'dailyTaps': 0,
//           'lastTapDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
//         });
//       }
//     }
//   }

//   // Method to update counter and daily taps in Firestore
//   Future<void> _updateCounter() async {
//     User? user = _auth.currentUser; // Get the current user
//     if (user != null) {
//       await _firestore.collection('users').doc(user.uid).set({
//         'counter': _counter, // Save total taps to Firestore
//       }, SetOptions(merge: true)); // Merge to avoid overwriting other fields
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
//     }
//   }

//   void _toggleAnimation() {
//     if (_dailyTaps < _dailyLimit) {
//       // Check if the daily tap limit has been reached
//       setState(() {
//         _isAnimating = !_isAnimating;
//         _counter++; // Increment the total counter on each tap
//         _dailyTaps++; // Increment the daily counter
//       });
//       _updateCounter(); // Update total counter in Firestore
//       _updateDailyTaps(
//           _dailyTaps,
//           DateFormat('yyyy-MM-dd')
//               .format(DateTime.now())); // Update daily taps in Firestore
//     } else {
//       _showLimitReachedDialog(); // Show alert dialog when daily limit is reached
//     }
//   }

//   // Method to show an alert dialog when daily limit is reached
//   void _showLimitReachedDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Limit Reached'),
//           content: Text(
//             'You have reached your daily tap limit of $_dailyLimit.',
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Uicolor.body,
//       appBar: AppBar(
//         title: const Text(
//           'Ancient Ice Crystal',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
//         ),
//         backgroundColor: Uicolor.appBar,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             // Text("Season 1"),
//             Text(
//               'AIC Earned: $_counter', // Display total taps
//               style: const TextStyle(
//                 fontSize: 24,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             GestureDetector(
//               onTap:
//                   _toggleAnimation, // Trigger animation and counter increment on tap
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 120),
//                 width: _isAnimating ? 250 : 179, // Change size on animation
//                 height: _isAnimating ? 250 : 179,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.teal[800],
//                   boxShadow: const [
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
//               style: const TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//             ),
//             Center(
//                 child: GestureDetector(
//               child: Container(
//                 height: 45,
//                 width: MediaQuery.of(context).size.width / 2,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                   color: Colors.red,
//                 ),
//                 // color: Uicolor.error,
//                 child: Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "1 AD = 100AIC",
//                       ),
//                       SizedBox(
//                         width: 2,
//                       ),
//                       Image.asset('assets/icons/ads.png'),
//                     ],
//                   ),
//                 ),
//               ),
//             ))
//           ],
//         ),
//       ),
//     );
//   }
// }

///ADDED ADS

import 'package:air_drops/phase1/colors/UiColors.dart';
import 'package:air_drops/phase1/style/TextStyle.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // AdMob package

class CoinAnimationScreen extends StatefulWidget {
  const CoinAnimationScreen({super.key});

  @override
  _CoinAnimationScreenState createState() => _CoinAnimationScreenState();
}

class _CoinAnimationScreenState extends State<CoinAnimationScreen> {
  bool _isAnimating = false;
  int _counter = 0;
  int _dailyTaps = 0;
  int _adsWatched = 0; // Total ads watched
  final int _dailyLimit = 200;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RewardedAd? _rewardedAd; // Rewarded ad instance

  @override
  void initState() {
    super.initState();
    _loadCounter();
    _loadRewardedAd(); // Load an ad when initializing the screen
  }

  Future<void> _loadCounter() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          _counter = doc['counter'] ?? 0;
          _dailyTaps = doc['dailyTaps'] ?? 0;
          _adsWatched =
              doc['adsWatched'] ?? 0; // Load ads watched from Firestore
          String lastTapDate = doc['lastTapDate'] ?? '';
          String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

          if (lastTapDate != todayDate) {
            _dailyTaps = 0;
            _updateDailyTaps(0, todayDate);
          }
        });
      } else {
        await _firestore.collection('users').doc(user.uid).set({
          'counter': 0,
          'dailyTaps': 0,
          'adsWatched': 0, // Initialize ads watched
          'lastTapDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        });
      }
    }
  }

  Future<void> _updateCounter() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'counter': _counter,
      }, SetOptions(merge: true));
    }
  }

  Future<void> _updateDailyTaps(int dailyTaps, String lastTapDate) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'dailyTaps': dailyTaps,
        'lastTapDate': lastTapDate,
      }, SetOptions(merge: true));
    }
  }

  Future<void> _updateAdsWatched() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'adsWatched': _adsWatched, // Save ads watched to Firestore
      }, SetOptions(merge: true));
    }
  }

  void _toggleAnimation() {
    if (_dailyTaps < _dailyLimit) {
      setState(() {
        _isAnimating = !_isAnimating;
        _counter++;
        _dailyTaps++;
      });
      _updateCounter();
      _updateDailyTaps(
          _dailyTaps, DateFormat('yyyy-MM-dd').format(DateTime.now()));
    } else {
      _showLimitReachedDialog();
    }
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId:
          'ca-app-pub-9195160567434459/7505408398', // Replace with your AdMob Ad Unit ID
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  Future _showRewardedAd() async {
    if (_rewardedAd == null) {
      print('RewardedAd is not ready.');
      return showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text("Take Break"),
      content: Text("Wait for a MINUTE to Load ADS...."),
      actions: <Widget>[
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  },
);
;
    }

    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      setState(() {
        _adsWatched++;
        _counter += 100; // Increment counter by 100 for watching an ad
      });
      _updateAdsWatched(); // Update ads watched in Firestore
      _updateCounter(); // Update total counter in Firestore
      _loadRewardedAd(); // Load a new ad
    });

    _rewardedAd = null;
  }

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
                Navigator.of(context).pop();
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
        title: const Text(
          'Ancient Ice Crystal',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Uicolor.appBar,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'AIC Earned: $_counter',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: _toggleAnimation,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: _isAnimating ? 250 : 179,
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
                      fontSize: _isAnimating ? 100 : 69,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              'Daily AIC: $_dailyTaps / $_dailyLimit',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),

            ElevatedButton.icon(
              onPressed: _showRewardedAd,
              label: Text("1 AD = 100AIC"),
              icon: Image.asset('assets/icons/ads.png',width: 24,height: 24,),
            ),

            // IconButton(
            //   onPressed: _showRewardedAd,
            //   icon: Image.asset(
            //     height: 25,
            //     width: 25,
            //     'assets/icons/ads.png',
            //   ),
            // ),
            // GestureDetector(
            //   onTap: _showRewardedAd, // Trigger ad watching
            //   child: Container(
            //     height: 45,
            //     width: MediaQuery.of(context).size.width / 2,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.all(Radius.circular(10)),
            //       color: Colors.teal,
            //     ),
            //     child: Center(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text("1 AD = 100AIC",style: TextStyle(fontSize: 18,color: Colors.blueAccent),),
            //           SizedBox(width: 2),
            //           Image.asset('assets/icons/ads.png'),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
