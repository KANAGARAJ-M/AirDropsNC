// // // import 'dart:convert';
// // // import 'dart:math';
// // // import 'package:air_drops/customs/GoogleProgressBarC.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:google_mobile_ads/google_mobile_ads.dart';
// // // import 'package:url_launcher/url_launcher.dart';



// // // class ItemListScreen extends StatefulWidget {
// // //   @override
// // //   _ItemListScreenState createState() => _ItemListScreenState();
// // // }

// // // class _ItemListScreenState extends State<ItemListScreen> {
// // //   List<dynamic> items = [];
// // //   List<BannerAd> bannerAds = [];
// // //   InterstitialAd? _interstitialAd;
// // //   bool _isInterstitialAdReady = false;
// // //   Future<void> fetchData() async {
// // //     final response =
// // //         await http.get(Uri.parse('https://airdrops.7rounds.xyz/Items.json'));
// // //     final response1 = await http
// // //         .get(Uri.parse('https://zingy-choux-d97768.netlify.app/Items.json'));
// // //     if (response.statusCode == 200 || response1.statusCode == 200) {
// // //       setState(() {
// // //         items = json.decode(response.body)['items'];
// // //         _loadBannerAds();
// // //       });
// // //     } else {
// // //       throw Exception('Failed to load data');
// // //     }
// // //   }
// // //   List<String> adUnitIds = [
// // //     'ca-app-pub-9195160567434459/5624750474',
// // //     'ca-app-pub-9195160567434459/6724648538', 
// // //     'ca-app-pub-9195160567434459/5411566865',
// // //     'ca-app-pub-9195160567434459/8679995515',
// // //     'ca-app-pub-9195160567434459/9845737526',
// // //     'ca-app-pub-9195160567434459/2785403520',
// // //     'ca-app-pub-9195160567434459/5589329139',
// // //     'ca-app-pub-9195160567434459/5891014798',
// // //   ];
// // //   String getRandomAdUnitId() {
// // //     Random random = Random();
// // //     int randomIndex = random.nextInt(adUnitIds.length);
// // //     return adUnitIds[randomIndex];
// // //   }
// // //   void _loadBannerAds() {
// // //     for (int i = 0; i < (items.length / 4).ceil(); i++) {
// // //       String adUnitId = getRandomAdUnitId();
// // //       BannerAd bannerAd = BannerAd(
// // //         adUnitId: adUnitId,
// // //         request: AdRequest(),
// // //         size: AdSize.banner,
// // //         listener: BannerAdListener(
// // //           onAdLoaded: (Ad ad) => setState(() {}),
// // //           onAdFailedToLoad: (Ad ad, LoadAdError error) {
// // //             ad.dispose();
// // //           },
// // //         ),
// // //       );
// // //       bannerAd.load();
// // //       bannerAds.add(bannerAd);
// // //     }
// // //   }
// // //   void _loadInterstitialAd() {
// // //     String adIntId = 'ca-app-pub-9195160567434459/5028525110';
// // //     InterstitialAd.load(
// // //       adUnitId: adIntId, 
// // //       request: AdRequest(),
// // //       adLoadCallback: InterstitialAdLoadCallback(
// // //         onAdLoaded: (InterstitialAd ad) {
// // //           _interstitialAd = ad;
// // //           _isInterstitialAdReady = true;
// // //         },
// // //         onAdFailedToLoad: (LoadAdError error) {
// // //           _isInterstitialAdReady = false;
// // //         },
// // //       ),
// // //     );
// // //   }
// // //   void _showInterstitialAd() {
// // //     if (_isInterstitialAdReady && _interstitialAd != null) {
// // //       _interstitialAd!.show();
// // //       _interstitialAd = null;
// // //       _loadInterstitialAd();
// // //     }
// // //   }

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     fetchData();
// // //     _loadInterstitialAd(); 
// // //   }

// // //   @override
// // //   void dispose() {
// // //     for (var ad in bannerAds) {
// // //       ad.dispose();
// // //     }
// // //     _interstitialAd?.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.blue[400],
// // //       appBar: AppBar(
// // //         backgroundColor: Colors.blue[400],
// // //         title: const Text('Tasks'),
// // //         actions: [
// // //           IconButton(
// // //             onPressed: () {
// // //               showDialog(
// // //                 context: context,
// // //                 builder: (BuildContext context) {
// // //                   return AlertDialog(
// // //                     title: const Text('App Info'),
// // //                     content: const Text('Version : 1.4 - testing'),
// // //                     actions: <Widget>[
// // //                       TextButton(
// // //                         child: Text('Close'),
// // //                         onPressed: () {
// // //                           Navigator.of(context).pop();
// // //                         },
// // //                       ),
// // //                     ],
// // //                   );
// // //                 },
// // //               );
// // //             },
// // //             icon: const Icon(
// // //               Icons.info,
// // //               color: Colors.black,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //       body: Column(
// // //         children: [
// // //           // Container(
// // //           //   margin: const EdgeInsets.all(8),
// // //           //   padding: const EdgeInsets.all(40),
// // //           //   width: MediaQuery.of(context).size.width,
// // //           //   decoration: BoxDecoration(
// // //           //     color: Colors.white,
// // //           //     borderRadius: BorderRadius.circular(10),
// // //           //     boxShadow: const [
// // //           //       BoxShadow(
// // //           //         color: Colors.black26,
// // //           //         blurRadius: 5,
// // //           //       ),
// // //           //     ],
// // //           //   ),
// // //           //   child: Column(
// // //           //     children: [
// // //           //       Text(
// // //           //         'Welcome to AirDrops - NC!',
// // //           //         style: TextStyle(
// // //           //           color: Colors.blue[900],
// // //           //           fontSize: 18,
// // //           //           fontWeight: FontWeight.bold,
// // //           //         ),
// // //           //       ),
// // //           //     ],
// // //           //   ),
// // //           // ),
// // //           Expanded(
// // //             child: items.isEmpty
// // //                 ? Center(child: GoogleColorChangingProgressBar())
// // //                 : ListView.builder(
// // //                     itemCount: items.length + bannerAds.length,
// // //                     itemBuilder: (context, index) {
// // //                       if (index % 5 == 0 && index ~/ 5 < bannerAds.length) {
// // //                         final BannerAd bannerAd = bannerAds[index ~/ 5];
// // //                         return Container(
// // //                           margin: const EdgeInsets.symmetric(vertical: 10),
// // //                           height: 50,
// // //                           child: AdWidget(ad: bannerAd),
// // //                         );
// // //                       }
// // //                       final itemIndex = index - (index ~/ 5 + 1);
// // //                       final item = items[itemIndex];

// // //                       return Column(
// // //                         children: [
// // //                           Container(
// // //                             width: MediaQuery.of(context).size.width,
// // //                             height: MediaQuery.of(context).size.height / 15,
// // //                             child: ListTile(
// // //                               leading: Image.network(item['imageLink'],
// // //                                   width: 50, height: 50, fit: BoxFit.cover),
// // //                               title: Text(item['title']),
// // //                               subtitle: Text(item['shortDescription']),
// // //                               onTap: () {
// // //                                 _showInterstitialAd();
// // //                                 Navigator.push(
// // //                                   context,
// // //                                   MaterialPageRoute(
// // //                                     builder: (context) =>
// // //                                         ItemDetailScreen(item: item),
// // //                                   ),
// // //                                 );
// // //                               },
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       );
// // //                     },
// // //                   ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // // 


// // // class ItemDetailScreen extends StatefulWidget {
// // //   final dynamic item;

// // //   ItemDetailScreen({required this.item});

// // //   @override
// // //   _ItemDetailScreenState createState() => _ItemDetailScreenState();
// // // }

// // // class _ItemDetailScreenState extends State<ItemDetailScreen> {
// // //   final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
// // //   final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
// // //   bool _isButtonEnabled = true; // Button enabled state

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //   }

// // //   void _launchURL(String url) async {
// // //     if (await canLaunch(url)) {
// // //       await launch(
// // //         url,
// // //         forceSafariVC: false, // Do not use in-app browser for iOS
// // //         forceWebView: true, // Do not use WebView for Android
// // //         enableJavaScript: true,
// // //       );
// // //     } else {
// // //       throw 'Could not launch $url';
// // //     }
// // //   }

// // //   Future<void> _updateCounter() async {
// // //     User? user = _auth.currentUser; // Get the current user
// // //     if (user != null) {
// // //       DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
// // //       int currentCounter = doc['counter'] ?? 0; // Get current counter from Firestore
// // //       await _firestore.collection('users').doc(user.uid).set({
// // //         'counter': currentCounter + 500, // Increment counter by 500
// // //       }, SetOptions(merge: true)); // Merge to avoid overwriting other fields
// // //     }
// // //   }

// // //   void _handleButtonClick() async {
// // //     await _updateCounter(); // Update counter in Firestore
// // //     setState(() {
// // //       _isButtonEnabled = false; // Disable the button after click
// // //     });
    
// // //     // Launch URL after updating the counter
// // //     final String linkAppOpen = widget.item['buttonLink'];
// //     // final Uri _url = Uri.parse(linkAppOpen);
// //     // await launchUrl(
// //     //   _url,
// //     //   mode: LaunchMode.platformDefault,
// //     //   webViewConfiguration: const WebViewConfiguration(
// //     //     enableJavaScript: true,
// //     //   ),
// //     // );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(widget.item['title']),
// // //       ),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Image.network(widget.item['imageLink']),
// // //             SizedBox(height: 10),
// // //             Text(
// // //               widget.item['title'],
// // //               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// // //             ),
// // //             SizedBox(height: 10),
// // //             Text(widget.item['description']),
// // //             SizedBox(height: 20),
// // //             Center(
// // //               child: ElevatedButton(
// // //                 onPressed: _isButtonEnabled ? _handleButtonClick : null, // Disable if button is clicked
// // //                 child: Text('Open Now'),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

























// import 'dart:convert';
// import 'dart:math';
// import 'package:air_drops/customs/GoogleProgressBarC.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ItemListScreen extends StatefulWidget {
//   @override
//   _ItemListScreenState createState() => _ItemListScreenState();
// }

// class _ItemListScreenState extends State<ItemListScreen> {
//   List<dynamic> items = [];
//   List<BannerAd> bannerAds = [];
//   InterstitialAd? _interstitialAd;
//   bool _isInterstitialAdReady = false;

//   Future<void> fetchData() async {
//     final response =
//         await http.get(Uri.parse('https://airdrops.7rounds.xyz/Items.json'));
//     final response1 = await http
//         .get(Uri.parse('https://zingy-choux-d97768.netlify.app/Items.json'));
//     if (response.statusCode == 200 || response1.statusCode == 200) {
//       setState(() {
//         items = json.decode(response.body)['items'];
//         _loadBannerAds();
//       });
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   List<String> adUnitIds = [
//     // Your ad unit IDs
//   ];

//   String getRandomAdUnitId() {
//     Random random = Random();
//     int randomIndex = random.nextInt(adUnitIds.length);
//     return adUnitIds[randomIndex];
//   }

//   void _loadBannerAds() {
//     for (int i = 0; i < (items.length / 4).ceil(); i++) {
//       String adUnitId = getRandomAdUnitId();
//       BannerAd bannerAd = BannerAd(
//         adUnitId: adUnitId,
//         request: AdRequest(),
//         size: AdSize.banner,
//         listener: BannerAdListener(
//           onAdLoaded: (Ad ad) => setState(() {}),
//           onAdFailedToLoad: (Ad ad, LoadAdError error) {
//             ad.dispose();
//           },
//         ),
//       );
//       bannerAd.load();
//       bannerAds.add(bannerAd);
//     }
//   }

//   void _loadInterstitialAd() {
//     String adIntId = 'ca-app-pub-9195160567434459/5028525110';
//     InterstitialAd.load(
//       adUnitId: adIntId,
//       request: AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (InterstitialAd ad) {
//           _interstitialAd = ad;
//           _isInterstitialAdReady = true;
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           _isInterstitialAdReady = false;
//         },
//       ),
//     );
//   }

//   void _showInterstitialAd() {
//     if (_isInterstitialAdReady && _interstitialAd != null) {
//       _interstitialAd!.show();
//       _interstitialAd = null;
//       _loadInterstitialAd();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//     _loadInterstitialAd();
//   }

//   @override
//   void dispose() {
//     for (var ad in bannerAds) {
//       ad.dispose();
//     }
//     _interstitialAd?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[400],
//       appBar: AppBar(
//         backgroundColor: Colors.blue[400],
//         title: const Text('Tasks'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: const Text('App Info'),
//                     content: const Text('Version : 1.4 - testing'),
//                     actions: <Widget>[
//                       TextButton(
//                         child: Text('Close'),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//             icon: const Icon(
//               Icons.info,
//               color: Colors.black,
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: items.isEmpty
//                 ? Center(child: GoogleColorChangingProgressBar())
//                 : ListView.builder(
//                     itemCount: items.length + bannerAds.length,
//                     itemBuilder: (context, index) {
//                       // Show banner ads at random positions
//                       if (index % 5 == 0 && index ~/ 5 < bannerAds.length) {
//                         final BannerAd bannerAd = bannerAds[index ~/ 5];
//                         return Container(
//                           margin: const EdgeInsets.symmetric(vertical: 10),
//                           height: 50,
//                           child: AdWidget(ad: bannerAd),
//                         );
//                       }
//                       final itemIndex = index - (index ~/ 5 + 1);
//                       final item = items[itemIndex];

//                       return TaskItem(
//                         item: item,
//                         onClaim: (reward) {
//                           // Handle reward claiming
//                           _showInterstitialAd();
//                           // Update the user counter here
//                           _updateUserCounter(reward);
//                         },
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _updateUserCounter(int reward) async {
//     User? user = FirebaseAuth.instance.currentUser; // Get the current user
//     if (user != null) {
//       DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//       int currentCounter = doc['counter'] ?? 0; // Get current counter from Firestore
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//         'counter': currentCounter + reward, // Increment counter by the reward
//       }, SetOptions(merge: true)); // Merge to avoid overwriting other fields
//     }
//   }
// }

// class TaskItem extends StatefulWidget {
//   final dynamic item;
//   final Function(int) onClaim;

//   TaskItem({required this.item, required this.onClaim});

//   @override
//   _TaskItemState createState() => _TaskItemState();
// }

// class _TaskItemState extends State<TaskItem> {
//   bool _isButtonEnabled = false;

//   void _handleTaskClick() {
//     setState(() {
//       _isButtonEnabled = true; // Enable the button when the task is clicked
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _handleTaskClick, // Enable button on task click
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height / 10,
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Image.network(widget.item['imageLink'], width: 50, height: 50, fit: BoxFit.cover),
//                 SizedBox(width: 10),
//                 Text(widget.item['title'], style: TextStyle(fontSize: 16)),
//               ],
//             ),
//             ElevatedButton(
//               onPressed: _isButtonEnabled
//                   ? () {
//                       widget.onClaim(widget.item['reward']); // Call onClaim with the reward
//                       setState(() {
//                         _isButtonEnabled = false; // Disable the button permanently
//                       });
//                     }
//                   : null, // Disable button until task is clicked
//               child: Text('${widget.item['reward']} points'), // Display the reward amount
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
