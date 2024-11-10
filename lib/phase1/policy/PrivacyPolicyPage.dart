// import 'package:air_drops/phase1/colors/UiColors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class PrivacyPolicyScreen extends StatefulWidget {
//   const PrivacyPolicyScreen({super.key});

//   @override
//   _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
// }

// class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
//   // late InAppWebViewController _controller;

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Uicolor.body,
  //     appBar: AppBar(
  //       backgroundColor: Uicolor.appBar,
  //       title: const Text('Privacy Policy'),
  //     ),
  //     body: InAppWebView(
  //       initialUrlRequest: URLRequest(
  //         url: WebUri("https://aicnc.netlify.app/policy/aic-coin-policy"),
          
  //       ),

  //     ),
  //   );
  // }
// }




import 'package:air_drops/phase1/colors/UiColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Uicolor.body,
      appBar: AppBar(
        backgroundColor: Uicolor.appBar,
        title: const Text('Privacy Policy'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("https://aicnc.netlify.app/policy/aic-coin-policy"),
          
        ),

      ),
    );
  }
}