import 'dart:convert';
import 'dart:math';
import 'package:air_drops/Screen/Splash.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class NewM extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AirDrops - NC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ItemListScreen extends StatefulWidget {
  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  List<dynamic> items = [];
  List<BannerAd> bannerAds = [];
  // List<String> _intAds = [];
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  // Load data from the server
  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://airdrops.7rounds.xyz/Items.json'));
    final response1 = await http
        .get(Uri.parse('https://zingy-choux-d97768.netlify.app/Items.json'));
    if (response.statusCode == 200 || response1.statusCode == 200) {
      setState(() {
        items = json.decode(response.body)['items'];
        _loadBannerAds();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  // List<String> _intAds = [
  //   'ca-app-pub-9195160567434459/5028525110',
  //   'ca-app-pub-9195160567434459/2452029908',
  //   'ca-app-pub-9195160567434459/2179000490',
  //   'ca-app-pub-9195160567434459/4018695773',
  //   'ca-app-pub-9195160567434459/5397757442',
  // ];

  // String getIntAds() {
  //   Random random = Random();
  //   int randomIndex = random.nextInt(_intAds.length);
  //   return adUnitIds[randomIndex];
  // }

  List<String> adUnitIds = [
    'ca-app-pub-9195160567434459/5624750474',
    'ca-app-pub-9195160567434459/6724648538', // Additional ad unit IDs
    'ca-app-pub-9195160567434459/5411566865',
    'ca-app-pub-9195160567434459/8679995515',
    'ca-app-pub-9195160567434459/9845737526',
    'ca-app-pub-9195160567434459/2785403520',
    'ca-app-pub-9195160567434459/5589329139',
    'ca-app-pub-9195160567434459/5891014798',
  ];
  String getRandomAdUnitId() {
    Random random = Random();
    int randomIndex = random.nextInt(adUnitIds.length);
    return adUnitIds[randomIndex];
  }

  // Load banner ads
  // void _loadBannerAds() {
  //   for (int i = 0; i < (items.length / 4).ceil(); i++) {
  //     BannerAd bannerAd = BannerAd(
  //       adUnitId:
  //           'ca-app-pub-9195160567434459/5624750474', // Replace with your Ad Unit ID
  //       request: AdRequest(),
  //       size: AdSize.banner,
  //       listener: BannerAdListener(
  //         onAdLoaded: (Ad ad) => setState(() {}),
  //         onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //           ad.dispose();
  //         },
  //       ),
  //     );
  //     bannerAd.load();
  //     bannerAds.add(bannerAd);
  //   }
  // }
  void _loadBannerAds() {
    for (int i = 0; i < (items.length / 4).ceil(); i++) {
      String adUnitId = getRandomAdUnitId();
      // String adUnitId = adUnitIds[i % adUnitIds.length]; // Cycle through or use a random adUnitId
      BannerAd bannerAd = BannerAd(
        // adUnitId: getRandomAdUnitId(),
        adUnitId: adUnitId,
        request: AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) => setState(() {}),
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
          },
        ),
      );
      bannerAd.load();
      bannerAds.add(bannerAd);
    }
  }

  // Load interstitial ad
  void _loadInterstitialAd() {
    String adIntId = 'ca-app-pub-9195160567434459/5028525110';
    InterstitialAd.load(
      adUnitId: adIntId, // Replace with your Ad Unit ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  // Show interstitial ad
  void _showInterstitialAd() {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null; // Reset after showing
      _loadInterstitialAd(); // Load the next interstitial ad
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _loadInterstitialAd(); // Load interstitial ad when the screen is initialized
  }

  @override
  void dispose() {
    for (var ad in bannerAds) {
      ad.dispose();
    }
    _interstitialAd?.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchData();
  // }

  // @override
  // void dispose() {
  //   for (var ad in bannerAds) {
  //     ad.dispose();
  //   }
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text('AirDrops - NC'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('App Info'),
                      content: Text('Version : 1.1'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.info,
                color: Colors.black,
              ))
        ],
      ),
      body: items.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: items.length + bannerAds.length,
              itemBuilder: (context, index) {
                // Determine if it's time to show an ad
                if (index % 5 == 0 && index ~/ 5 < bannerAds.length) {
                  final BannerAd bannerAd = bannerAds[index ~/ 5];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 50,
                    child: AdWidget(ad: bannerAd),
                  );
                }

                // Calculate the actual index in the items list
                final itemIndex = index - (index ~/ 5 + 1);
                final item = items[itemIndex];

                return ListTile(
                  leading: Image.network(item['imageLink'],
                      width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item['title']),
                  subtitle: Text(item['shortDescription']),
                  onTap: () {
                    _showInterstitialAd();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailScreen(item: item),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class ItemDetailScreen extends StatelessWidget {
  final dynamic item;

  ItemDetailScreen({required this.item});

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false, // Do not use in-app browser for iOS
        forceWebView: true, // Do not use WebView for Android
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _fromOffL() async {
    final Uri _url = Uri.parse(item['buttonLink']);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  void _launchURLN() async {
    final Uri _url = Uri.parse(item['buttonLink']);
    if (await canLaunchUrl(_url)) {
      await launchUrl(
        _url,
        mode: LaunchMode.platformDefault,

        // url,
        // forceSafariVC: false, // Do not use in-app browser for iOS
        // forceWebView: true, // Do not use WebView for Android
        // enableJavaScript: true,
      );
    } else {
      throw 'Could not launch';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(item['imageLink']),
            SizedBox(height: 10),
            Text(
              item['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(item['description']),
            SizedBox(height: 20),
            Center(
              child:
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Open button link in browser (use url_launcher)
                  //     // _launchURL(item['buttonLink']);
                  //     // _launchURLN();
                  //     _fromOffL();
                  //   },
                  //   child: Text('Open Now'),
                  // ),

                  ElevatedButton(
                onPressed: () async {
                  final String linkappopen = item['buttonLink'];
                  final Uri _url = Uri.parse(linkappopen);
                  await launchUrl(
                    _url,
                    mode: LaunchMode.platformDefault,
                    webViewConfiguration: const WebViewConfiguration(
                      enableJavaScript: true,
                    ),
                  );
                },
                child: Text(
                  // 'Open App',
                  // item['Open-App-Button-Text'],
                  'Open Now',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
