library version_updater;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

/// VersionUpdater class to check for app updates on iOS and Android.
class VersionUpdater {
  static String _currentVersion = "";
  static String _latestIosVersion = "";
  static String _latestAndroidVersion = "";

  /// Function to initialize the version checking process.
  static Future<void> checkForUpdate(BuildContext context,
      {required String iosAppId, required String androidAppId}) async {
    // Get the current app version
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _currentVersion = packageInfo.version;

    // Fetch the latest versions from the app stores
    await _getLatestVersionFromIOS(iosAppId);
    await _getLatestVersionFromAndroid(androidAppId);

    bool forceUpdate = false;

    // Compare versions and determine if an update is needed
    if (Platform.isIOS) {
      forceUpdate = _isUpdateRequired(_currentVersion, _latestIosVersion);
    } else if (Platform.isAndroid) {
      forceUpdate = _isUpdateRequired(_currentVersion, _latestAndroidVersion);
    }

    // If an update is needed, show the update dialog
    if (forceUpdate) {
      _showUpdateDialog(context, iosAppId: iosAppId, androidAppId: androidAppId);
    }
  }

  // Function to fetch the latest version from the iOS App Store
  static Future<void> _getLatestVersionFromIOS(String iosAppId) async {
    final response =
        await http.get(Uri.parse('https://itunes.apple.com/lookup?id=$iosAppId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['resultCount'] > 0) {
        _latestIosVersion = data['results'][0]['version'];
      }
    } else {
      throw Exception('Failed to load latest version from iOS App Store');
    }
  }

  // Function to fetch the latest version from the Google Play Store
  static Future<void> _getLatestVersionFromAndroid(String androidAppId) async {
    final response = await http.get(Uri.parse(
        'https://play.google.com/store/apps/details?id=$androidAppId&hl=en'));
    if (response.statusCode == 200) {
      final document = response.body;
      final versionRegex =
          RegExp(r'Current Version</div><span.*?>\s*<div.*?>(.*?)<\/div>');
      final match = versionRegex.firstMatch(document);
      if (match != null) {
        _latestAndroidVersion = match.group(1)?.trim() ?? '';
      }
    } else {
      throw Exception('Failed to load latest version from Google Play Store');
    }
  }

  // Function to check if an update is required
  static bool _isUpdateRequired(String currentVersion, String latestVersion) {
    List<int> current = currentVersion.split('.').map(int.parse).toList();
    List<int> latest = latestVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < latest.length; i++) {
      if (current[i] < latest[i]) {
        return true;
      } else if (current[i] > latest[i]) {
        return false;
      }
    }
    return false;
  }

  // Function to show the update dialog
  static void _showUpdateDialog(BuildContext context,
      {required String iosAppId, required String androidAppId}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Update Required"),
        content: const Text("A new version is available. Please update to continue."),
        actions: [
          TextButton(
            onPressed: () {
              if (Platform.isIOS) {
                _launchURL(
                    'https://apps.apple.com/app/id$iosAppId');
              } else if (Platform.isAndroid) {
                _launchURL(
                    'https://play.google.com/store/apps/details?id=$androidAppId');
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // Function to launch the store link
  static Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
