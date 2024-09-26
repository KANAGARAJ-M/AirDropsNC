// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class WebViewScreen extends StatelessWidget {
//   final String url;

//   WebViewScreen({required this.url});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("WebView"),
//       ),
//       body: InAppWebView(
//         initialUrlRequest: URLRequest(url: Uri.parse(url)),
//         onWebViewCreated: (InAppWebViewController controller) {
//           // Optionally handle the WebView creation
//         },
//         onLoadStart: (controller, url) {
//           // Handle load start if needed
//         },
//         onLoadStop: (controller, url) async {
//           // Handle load stop if needed
//         },
//       ),
//     );
//   }
// }
