

// import 'package:air_drops/auth/auth_service.dart';
// import 'package:flutter/material.dart';
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
//       final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//       setState(() {
//         userData = doc.data();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[400],
//       appBar: AppBar(
//         title: const Text('Profile'),
//         backgroundColor: Colors.blue[400],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height / 4,
//           // color: Colors.green[400],
//           child: userData == null
//               ? const Center(child: CircularProgressIndicator()) // Show loading indicator while data is fetched
//               : Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           const TextSpan(
//                             text: 'Name \t\t\t: ',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black, // Black color for label
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           TextSpan(
//                             text: '${userData?['firstName'] ?? ''} ${userData?['lastName'] ?? ''}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.white, // White color for name
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           const TextSpan(
//                             text: 'Email\t\t\t: ',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black, // Black color for label
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           TextSpan(
//                             text: user?.email ?? '',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.white, // White color for email
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           const TextSpan(
//                             text: 'Phone\t\t\t: ',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black, // Black color for label
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           TextSpan(
//                             text: userData?['phone'] ?? '',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.white, // White color for phone number
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // RichText(
//                     //   text: TextSpan(
//                     //     children: [
//                     //       const TextSpan(
//                     //         text: 'Referral Code: ',
//                     //         style: TextStyle(
//                     //           fontSize: 16,
//                     //           color: Colors.black, // Black color for label
//                     //           fontWeight: FontWeight.bold,
//                     //         ),
//                     //       ),
//                     //       TextSpan(
//                     //         text: userData?['refCode'] ?? '',
//                     //         style: const TextStyle(
//                     //           fontSize: 16,
//                     //           color: Colors.white, // White color for referral code
//                     //           fontWeight: FontWeight.bold,
//                     //         ),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           const TextSpan(
//                             text: 'Verified: ',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black, // Black color for label
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           TextSpan(
//                             text: user?.emailVerified ?? false ? 'Verified' : 'Not Verified',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.white, // White color for verified status
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }
// }











import 'package:air_drops/colors/UiColors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:air_drops/auth/auth_service.dart';
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
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
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

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Uicolor.body,
      appBar: AppBar(
        title: const Text('Profile',style: TextStyle(fontWeight: FontWeight.w700),),
        backgroundColor: Uicolor.appBar,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              // color: Colors.green[400],
              child: userData == null
                  ? const Center(child: CircularProgressIndicator()) // Show loading indicator while data is fetched
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
                                  color: Colors.black, // Black color for label
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '${userData?['firstName'] ?? ''} ${userData?['lastName']+"☑️" ?? ''}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white, // White color for name
                                  fontWeight: FontWeight.bold,
                                  
                                ),


                              ),
                              
                            ],
                          ),
                        ),
                        const SizedBox(height: 5,),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Email\t\t\t: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black, // Black color for label
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: user?.email ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white, // White color for email
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5,),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Country\t\t\t: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black, // Black color for label
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: userData?['country'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white, // White color for phone number
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5,),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Referral Code: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black, // Black color for label
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: userData?['referralCode'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white, // White color for referral code
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // RichText(
                        //   text: TextSpan(
                        //     children: [
                        //       const TextSpan(
                        //         text: 'Verified: ',
                        //         style: TextStyle(
                        //           fontSize: 16,
                        //           color: Colors.black, // Black color for label
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //       TextSpan(
                        //         text: user?.emailVerified ?? false ? 'Verified' : 'Not Verified',
                        //         style: const TextStyle(
                        //           fontSize: 16,
                        //           color: Colors.white, // White color for verified status
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
            ),
            
          ],
        ),
      ),
    );
  }
}
