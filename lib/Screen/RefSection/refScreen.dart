
import 'package:air_drops/colors/UiColors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart'; // For clipboard functionality
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart'; // For dynamic links

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  String referralCode = '';
  List<Map<String, dynamic>> referredUsers = [];
  String dynamicLinkUrl = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchReferralData();
  }

  // Fetch referral code and referred users
  void fetchReferralData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists) {
        setState(() {
          referralCode = userDoc['referralCode'] ?? '';
        });

        List referredUserIds = userDoc['referrals'] ?? [];
        if (referredUserIds.isNotEmpty) {
          for (String uid in referredUserIds) {
            DocumentSnapshot referredDoc = await _firestore.collection('users').doc(uid).get();
            if (referredDoc.exists) {
              setState(() {
                referredUsers.add({
                  'firstName': referredDoc['firstName'] ?? '',
                  'email': referredDoc['email'] ?? '',
                });
              });
            }
          }
        }

        // Generate a dynamic link with the referral code
        await _createDynamicLink(referralCode);
      }
    }
  }

  // Function to create a dynamic link
  Future<void> _createDynamicLink(String referralCode) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://airdropsnc.page.link', // Replace with your dynamic link domain
      link: Uri.parse('https://airdropsnc.page.link/refer?code=$referralCode'), // Add referral code as a query parameter
      androidParameters: const AndroidParameters(
        packageName: 'anc.nocorps.xyz', // Replace with your Android package name
        minimumVersion: 8,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'anc.nocorps.xyz', // 8Replace with your iOS bundle ID
        minimumVersion: '1.0.0',
      ),
    );

    final ShortDynamicLink shortDynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    setState(() {
      dynamicLinkUrl = shortDynamicLink.shortUrl.toString();
    });
  }

  // Function to copy text to clipboard
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard')),
      );
    });
  }

  void _shareYourCode(String text) {
    final String message = "Download our app from play store - https://play.google.com/store/apps/details?id=anc.nocorps.xyz  \nOpen our app and register an new user then fill the details.\nPaste your referral code while registration.\nYour REFERRAL CODE = $text";
    Share.share(message,subject: "Invite Code *$text*");
    // Share.share(text,);
  }


  void _shareReferralCode() {
  final String message =
      "Join me on this app! Use my referral code: $referralCode\n\n"
      "Or use this link: $dynamicLinkUrl";

    Share.share(message);
  }


  //Download our app from play store.\nOpen our app and register an new user then fill the details.\nPaste your referral code while registration.\nYour REFERRAL CODE = $referralCode

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Uicolor.body,
      appBar: AppBar(
        backgroundColor: Uicolor.appBar,
        title: const Text("Refer Your Friends"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container to show referral code with copy option
            Container(
              height: MediaQuery.of(context).size.height / 6,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.blue,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Your Referral Code:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          referralCode,
                          style: const TextStyle(fontSize: 16, color: Colors.blue),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () => _shareYourCode(referralCode),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 20),
            // Container to show referral link with copy option
            // Container(
            //   height: MediaQuery.of(context).size.height / 6,
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(6),
            //     border: Border.all(
            //       color: Colors.blue,
            //     ),
            //   ),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       const Text(
            //         "Your Referral Link:",
            //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //       ),
            //       const SizedBox(height: 8),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Expanded(
            //             child: Text(
            //               dynamicLinkUrl,
            //               style: const TextStyle(fontSize: 16, color: Colors.blue),
            //               overflow: TextOverflow.ellipsis,
            //             ),
            //           ),
            //           IconButton(
            //             icon: const Icon(Icons.copy),
            //             onPressed: () => _copyToClipboard(dynamicLinkUrl),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 20),
            const Text(
              "Referred Friends:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            // List of referred friends
            Expanded(
              child: referredUsers.isNotEmpty
                  ? ListView.builder(
                      itemCount: referredUsers.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(referredUsers[index]['firstName'] ?? 'No Name'),
                            subtitle: Text(referredUsers[index]['email'] ?? 'No Email'),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        "No referrals yet.",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
