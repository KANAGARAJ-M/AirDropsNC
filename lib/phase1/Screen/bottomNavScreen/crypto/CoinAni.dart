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
        title: Text(
          'AIC Earned: $_counter',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Uicolor.appBar,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Uicolor.appBar,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.blue,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "How to Get AIC AIRDROP!",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "1 - Invite your friends to join the AIC AIRDROP",
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "2 - Watch ADS to earn AIC",
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "3 - Finish all the tasks to earn more AIC",
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "4 - Earn more AIC by watching ADS",
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 17),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Uicolor.appBar,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.blue,
                  ),
                ),
                child: Row(
                  children: [
                    Text("Earn AIC by viewing ads"),
                    SizedBox(width: 5),
                    ElevatedButton.icon(
                      onPressed: _showRewardedAd,
                      label: Text(
                        "1 AD = 100AIC",
                        style: TextStyle(color: Uicolor.text),
                      ),
                      icon: Image.asset(
                        'assets/icons/ads.png',
                        width: 15,
                        height: 15,
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Uicolor.appBar,
                        backgroundColor: Uicolor.body,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
