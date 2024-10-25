import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionControl {
  final FirebaseRemoteConfig remoteConfig;

  VersionControl({required this.remoteConfig});

  // Initialize Firebase Remote Config
  Future<void> initializeRemoteConfig() async {
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1), // Timeout duration for fetching
        minimumFetchInterval: const Duration(hours: 1), // Minimum interval for fetching
      ));

      // Fetch the remote config values from Firebase
      await remoteConfig.fetchAndActivate();
    } catch (e) {
      print('Failed to fetch remote config: $e');
    }
  }

  // Check app version with the minimum required version
  Future<void> checkAppVersion(BuildContext context) async {
    try {
      // Get current app version using package_info_plus
      final packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // Get the minimum required version from Firebase Remote Config
      String minimumVersion = remoteConfig.getString('minimum_version');

      // If the current version is less than the minimum version, show update dialog
      if (_isVersionOutdated(currentVersion, minimumVersion)) {
        _showUpdateDialog(context, minimumVersion);
      }
    } catch (error) {
      print('Error checking app version: $error');
    }
  }

  // Compare app versions (return true if update is needed)
  bool _isVersionOutdated(String currentVersion, String minimumVersion) {
    final currentParts = currentVersion.split('.').map(int.parse).toList();
    final minimumParts = minimumVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < minimumParts.length; i++) {
      if (currentParts[i] < minimumParts[i]) return true;
      if (currentParts[i] > minimumParts[i]) return false;
    }

    return false; // Return false if versions are equal
  }

  // Show update dialog to the user
  void _showUpdateDialog(BuildContext context, String minimumVersion) {
    showDialog(
      context: context,
      barrierDismissible: false, // Force user to update
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Required'),
          content: Text('A new version of the app ($minimumVersion) is available. Please update to continue.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Update Now'),
              onPressed: () {
                // Redirect user to the app store (or custom URL for updates)
                _launchAppStore();
              },
            ),
          ],
        );
      },
    );
  }

  // Launch the app store for update
  Future<void> _launchAppStore() async {
    const url = 'https://play.google.com/store/apps/details?id=airdrops.nocorps.xyz'; // Replace with your app's Play Store link
    const String linkAppOpen = url;
    final Uri url0 = Uri.parse(linkAppOpen);
    await launchUrl(
      url0,
      mode: LaunchMode.platformDefault,
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true,
      ),
    );
  }
}
