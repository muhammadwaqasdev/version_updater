import 'package:flutter/material.dart';
import 'package:version_updater/version_updater.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Version Check Example',
      home: VersionCheckScreen(),
    );
  }
}

class VersionCheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VersionUpdater.checkForUpdate(
        context,
        iosAppId: '6670390742', // Your iOS App ID
        androidAppId: 'co.ziara.booking.app', // Your Android App package name
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text("Version Updater Example")),
      body: Center(child: Text("Welcome to the app!")),
    );
  }
}
