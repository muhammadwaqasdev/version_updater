
# Version Updater

A Flutter package to enforce app updates by checking the current version against the latest version from the App Store and Play Store. This package helps ensure that your users are always on the latest version of your app.

## Features

- **iOS Support**: Check for the latest app version available on the Apple App Store.
- **Android Support**: Check for the latest app version available on the Google Play Store.
- **Update Prompt**: Display a dialog to prompt users to update the app if a new version is available.
- **URL Launching**: Direct users to the app store for updating the app.

## Supported Platforms

- **iOS**: Requires a valid App Store ID for version checking.
- **Android**: Requires a valid package name for version checking.

## Installation

To use the `version_updater` package, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  version_updater: ^0.0.1
 ```
 
Then run:
 ```bash
 flutter pub get
```

## Usage

Import the package and use the `VersionUpdater` class to check for updates. Below is an example of how to use the package in your Flutter app:

```dart
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
        iosAppId: 'YOUR_IOS_APP_ID', // Replace with your iOS App ID
        androidAppId: 'YOUR_ANDROID_APP_ID', // Replace with your Android App package name
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text("Version Updater Example")),
      body: Center(child: Text("Welcome to the app!")),
    );
  }
}
```
Replace `YOUR_IOS_APP_ID` and `YOUR_ANDROID_APP_ID` with your respective app IDs.

## How It Works

1.  **Fetch Current Version**: Retrieves the current app version using the `package_info_plus` package.
2.  **Check Latest Version**:
    -   **iOS**: Fetches the latest version from the Apple App Store.
    -   **Android**: Scrapes the latest version from the Google Play Store.
3.  **Compare Versions**: Compares the current version with the latest version.
4.  **Prompt Update**: Shows an update dialog if a new version is available, directing users to the respective app store.

## Notes

-   **Version Format**: Ensure that the version format of your app is consistent with semantic versioning (e.g., `1.0.0`).
-   **Permissions**: No special permissions are required to use this package.
-   **Error Handling**: The package throws exceptions if it fails to retrieve version information. Ensure proper error handling in your app.

## Contributing

We welcome contributions to improve this package! Please refer to our [Contributing Guide](CONTRIBUTING.md) for more details on how to get involved.

## License

This package is licensed under the MIT License. See the LICENSE file for more details.

## Contact

For any questions or support, please contact muhammadwaqas0978@gmail.com.