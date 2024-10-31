import 'package:air_drops/phase1/colors/UiColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late InAppWebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Uicolor.body,
      appBar: AppBar(
        backgroundColor: Uicolor.appBar,
        title: const Text('Community'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("https://aic.7rounds.xyz/"),
        ),

      ),
    );
  }
}
