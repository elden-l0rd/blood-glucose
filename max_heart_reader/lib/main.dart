// Trilogy Technologies
// Project: Smart Wearable v5
// Project done by Matas Sabaliauskas (under Christopher Ng)
// Tested and Working on OnePlus Nord CE [ANDROID] device
// This will not work on an emulator as it will not find any bluetooth devices
// iOS app compiled for iOS but changes to flutter project need to be made, to allow all packages to work, and to gain all permissions
// background services are likely to work at 15 min intervals rather than 15 s
//
// Change the name of the app:
// https://stackoverflow.com/questions/49353199/how-can-i-change-the-app-display-name-build-with-flutter
//
// Change the icon of the app:
// https://pub.dev/packages/flutter_launcher_icons
//
// Change applicationId and bundle identifier to prevent overwrite
// https://stackoverflow.com/questions/58229150/how-to-run-a-copy-of-flutter-project-without-overwriting-the-existing-app
//
// Cloud database in real-time: influxDB
// https://www.influxdata.com/blog/getting-started-dart-influxdb/
//
// Run background service to keep uploading data when app is turned off
// https://pub.dev/packages/flutter_background_service
//
// Splash screen:
// https://pub.dev/packages/flutter_native_splash/example
// https://www.youtube.com/watch?v=dB0dOnc2k10&ab_channel=JohannesMilke
//
// Loading screen:
// https://codewithflutter.com/create-splash-screen-in-flutter-app/
//
// Enable and Check Location Permissions
// https://pub.dev/packages/permission_handler
//
// Allow power management in the background
// https://pub.dev/packages/wakelock
//
// to compile on iOS:
// 1. nil:NilClass for Flutter App / CocoaPod Error
// https://stackoverflow.com/questions/67443265/error-regarding-undefined-method-map-for-nilnilclass-for-flutter-app-cocoap
//
// 2. Make sure to click "Trust" on iPhone when connecting iPhone to PC
//
// 3. bundle ID error
// https://stackoverflow.com/questions/51098042/how-to-get-bundle-id-in-flutter
//
// 4. "Untrusted Developer" after XCode build is done.
// https://developer.apple.com/forums/thread/660288
// General -> VPN & Device Management -> Developer App -> Verify
//
// 5. Make sure that the sign in is successful in XCode:
// https://docs.flutter.dev/deployment/ios
// Go to XCode -> Runner -> Signing & Capabilities -> Team -> Select apple developer account
//
// 6. Dart SDK is not configured
// https://stackoverflow.com/questions/48650831/dart-sdk-is-not-configured
// Click on settings gear (IDE and Project Settings) -> Preferences -> Language & Framework -> Flutter -> choose flutter SDK
//
// 7. (when compiling Android app on Macbook): Execution failed for task ':app-compileFlutterBuildDebug'.
// https://stackoverflow.com/questions/61930007/how-to-solve-execution-failed-for-task-appcompileflutterbuilddebug

// Main dart/flutter libraries
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:max_heart_reader/user_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

// Project files
import 'bluetooth_off_screen.dart'; // 1st screen of the app (bluetooth off)
// 2nd screen of the app (find devices)
import 'background_service.dart'; // Background Service
import 'globals.dart' as globals; // Global variables
import 'find_devices.dart'
    as findDevicesWidget; // to display Toast notification
import 'background_ble_upload.dart' as background1;

// BLE
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// Custom splash background
// import 'package:flutter_native_splash/flutter_native_splash.dart';

// Check location permissions
import 'package:permission_handler/permission_handler.dart';

//New imports
import 'LandingPage/landing_page.dart';

Timer mytimer = Timer.periodic(Duration(seconds: 5), (timer) {
  background1.runBackgroundDeviceScan();
});

Future<void> getPermissions(context) async {
  if (await getLocationWhenInUsePermission() != 1) {
    debugPrint(
        'main.dart: getLocationWhenInUsePermission waiting for permission!');
  } else {
    debugPrint('main.dart: getLocationWhenInUsePermission SUCCESS!');
  }

  if (await getLocationAlwaysPermission() != 1) {
    debugPrint(
        'main.dart: getLocationAlwaysPermission waiting for permission!');
  } else {
    debugPrint('main.dart: getLocationAlwaysPermission SUCCESS!');
  }

  if (await getIgnoreBatteryOptimizationPermission() != 1) {
    debugPrint(
        'main.dart: getIgnoreBatteryOptimizationPermission waiting for permission!');
  } else {
    debugPrint('main.dart: getIgnoreBatteryOptimizationPermission SUCCESS!');
  }

  if (await getPushNotificationsPermission() != 1) {
    debugPrint(
        'main.dart: getPushNotificationsPermission waiting for permission!');
  } else {
    debugPrint('main.dart: getPushNotificationsPermission SUCCESS!');
  }

  checkPermissions(context);
}

Future<int> getLocationWhenInUsePermission() async {
  await Permission.locationWhenInUse
      .request(); // [WHILE USING THE APP / ONLY THIS TIME / DENY]

  if (await Permission.locationWhenInUse.request().isGranted) {
    // GRANTED
    return 1;
  } else {
    // RESTRICTED OR DENIED
    return 0;
  }
}

Future<int> getLocationAlwaysPermission() async {
  await Permission.locationAlways
      .request(); // [ALLOW ALL THE TIME / ALLOW ONLY WHILE USING THE APP / ASK EVERY TIME / DENY]

  if (await Permission.locationAlways.request().isGranted) {
    // GRANTED
    return 1;
  } else {
    // RESTRICTED OR DENIED
    return 0;
  }
}

Future<int> getIgnoreBatteryOptimizationPermission() async {
  await Permission.ignoreBatteryOptimizations.request(); // [ALLOW / DENY]

  if (await Permission.ignoreBatteryOptimizations.request().isGranted) {
    // GRANTED
    return 1;
  } else {
    // RESTRICTED OR DENIED
    return 0;
  }
}

Future<int> getPushNotificationsPermission() async {
  await Permission.notification.request(); // [ALLOW / DENY]

  if (await Permission.notification.request().isGranted) {
    // GRANTED
    return 1;
  } else {
    // RESTRICTED OR DENIED
    return 0;
  }
}

Future<void> checkPermissions(context) async {
  var locationWhenInUseStatus = await Permission.locationWhenInUse.status
      .isGranted; // null when it was not initialized, false if not granted, true if granted access
  var locationAlwaysStatus = await Permission.locationAlways.status.isGranted;
  var bluetoothStatus = await Permission.bluetooth.status.isGranted;
  var bluetoothScanStatus = await Permission.bluetoothScan.status.isGranted;
  var bluetoothAdvertiseStatus =
      await Permission.bluetoothAdvertise.status.isGranted;
  var bluetoothConnectStatus =
      await Permission.bluetoothConnect.status.isGranted;
  var batteryOptimizationsStatus =
      await Permission.ignoreBatteryOptimizations.status.isGranted;
  // var storeInExtStorageStatus = await Permission.storage.isGranted;
  var pushNotificationsPermission = await Permission.notification.isGranted;

  debugPrint(
      'main.dart: checkPermissions [locationWhenInUseStatus = $locationWhenInUseStatus]');
  debugPrint(
      'main.dart: checkPermissions [locationAlwaysStatus = $locationAlwaysStatus]');
  debugPrint(
      'main.dart: checkPermissions [bluetoothStatus = $bluetoothStatus]');
  debugPrint(
      'main.dart: checkPermissions [bluetoothScanStatus = $bluetoothScanStatus]');
  debugPrint(
      'main.dart: checkPermissions [bluetoothAdvertiseStatus = $bluetoothAdvertiseStatus]');
  debugPrint(
      'main.dart: checkPermissions [bluetoothConnectStatus = $bluetoothConnectStatus]');
  debugPrint(
      'main.dart: checkPermissions [batteryOptimizationsStatus = $batteryOptimizationsStatus]');
  debugPrint(
      'main.dart: checkPermissions [pushNotificationsPermission = $pushNotificationsPermission]');

  // if the user enables permissions successfully
  if (locationWhenInUseStatus && locationAlwaysStatus) {
    // start Background Service
    debugPrint('main.dart: checkPermissions initializing background service');
    await initializeService();

    // enable WakeLock
    // Does not work as expected so not required...
    //debugPrint('main.dart: checkPermissions enabling WakeLock!');
    //Wakelock.toggle(enable: true);

    globals.toastMessage = 'All Permissions Were Enabled Successfully!';
    findDevicesWidget.showToast();

    // go to the next widget: HomeScreen -> bluetooth_off_screen.dart OR find_devices.dart
    debugPrint('main.dart: checkPermissions opening HomeScreen in 2 seconds');
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    });

    // if the user denies permissions
  } else {
    debugPrint(
        'main.dart: checkPermissions Error! Some permissions were denied!');
    globals.toastMessage =
        'Permissions Were Not Enabled!\nPlease Enable in Settings';
    findDevicesWidget.showToast();

    openAppSettings();
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  // Required for background service
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeService(); // Do thxis later when all permissions are initialized
  await UserPreferences.init();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());

  // Save the database file on app exit
  SystemChannels.lifecycle.setMessageHandler((msg) async {
    if (msg == AppLifecycleState.paused.toString()) {
      // Copy the database file to a desired location
      final documentsDirectory = await getExternalStorageDirectory();
      final sourcePath = await getDatabasesPath() + '/data.db';
      final destinationPath = '${documentsDirectory!.path}/data.db';
      await File(sourcePath).copy(destinationPath);
    }
    return null;
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getPermissions(context);

    // Timer(const Duration(seconds: 5), ()=> {
    //     ()=>Navigator.pushReplacement(context,
    //     MaterialPageRoute(builder:
    //         (context) =>
    //             const HomeScreen()
    //     ))
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                Colors.orange,
              ]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/trilogy_logo.png",
              fit: BoxFit.fitHeight,
              height: 80,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.10),
            const Text(
              "Heart Reader",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.35),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<BluetoothState>(
        stream: FlutterBluePlus.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return LandingPage();
          }
          return BluetoothOffScreen(state: state);
        },
      ),
    );
  }
}
