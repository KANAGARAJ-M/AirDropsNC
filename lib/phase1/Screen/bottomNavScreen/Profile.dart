// import 'package:air_drops/phase1/colors/UiColors.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:air_drops/phase1/auth/auth_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final user = AuthService().currentUser;
//   Map<String, dynamic>? userData;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }

//   Future<void> fetchUserData() async {
//     if (user != null) {
//       // Fetch user data from Firestore
//       final userId = user?.uid;
//       final doc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();
//       setState(() {
//         userData = doc.data();
//       });
//     }
//   }

//   // Function to launch URLs
//   Future<void> _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Uicolor.body,
//       appBar: AppBar(
//         title: const Text(
//           'Profile',
//           style: TextStyle(fontWeight: FontWeight.w700),
//         ),
//         backgroundColor: Uicolor.appBar,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height / 3,
//               // color: Colors.green[400],
//               child: userData == null
//                   ? const Center(
//                       child:
//                           CircularProgressIndicator()) // Show loading indicator while data is fetched
//                   : Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         RichText(
//                           text: TextSpan(
//                             children: [
//                               const TextSpan(
//                                 text: 'Name \t\t\t: ',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.black, // Black color for label
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text:
//                                     '${userData?['firstName'] ?? ''} ${userData?['lastName'] + "☑️" ?? ''}',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.white, // White color for name
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         RichText(
//                           text: TextSpan(
//                             children: [
//                               const TextSpan(
//                                 text: 'Email\t\t\t: ',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.black, // Black color for label
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: user?.email ?? '',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.white, // White color for email
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         RichText(
//                           text: TextSpan(
//                             children: [
//                               const TextSpan(
//                                 text: 'Country\t\t\t: ',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.black, // Black color for label
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: userData?['country'] ?? '',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   color: Colors
//                                       .white, // White color for phone number
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         RichText(
//                           text: TextSpan(
//                             children: [
//                               const TextSpan(
//                                 text: 'Referral Code: ',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.black, // Black color for label
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: userData?['referralCode'] ?? '',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   color: Colors
//                                       .white, // White color for referral code
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }













import 'package:air_drops/phase1/auth/auth_page.dart';
import 'package:air_drops/phase1/colors/UiColors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:air_drops/phase1/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = AuthService().currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      // Fetch user data from Firestore
      final userId = user?.uid;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      setState(() {
        userData = doc.data();
      });
    }
  }

  // Function to launch URLs
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to sign out
  Future<void> _signOut() async {
    await AuthService().signOut();
    // Navigator.of(context).pushReplacementNamed('/login'); // Redirect to login
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Uicolor.body,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Uicolor.appBar,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut, // Call sign-out function on button press
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: userData == null
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Name \t\t\t: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${userData?['firstName'] ?? ''} ${userData?['lastName'] + "☑️" ?? ''}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Email\t\t\t: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: user?.email ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Country\t\t\t: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: userData?['country'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Referral Code: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: userData?['referralCode'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: _signOut,
            //   child: const Text('Sign Out'),
            // ),
          ],
        ),
      ),
    );
  }
}
