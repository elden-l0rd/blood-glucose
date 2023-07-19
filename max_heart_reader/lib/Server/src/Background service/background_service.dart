// ignore_for_file: constant_identifier_names

// Purpose: Initialises background service for scanning.

// Flutter/Dart
import 'dart:async';
import 'dart:io';
import 'dart:ui';
// Project files
// import 'main.dart';
import 'background_ble_scan.dart';
import '../../../utils/globals.dart' as globals;
// Background Service libraries
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('background_service: FLUTTER BACKGROUND FETCH');

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: globals.BLE_SCAN_INTERVAL), (timer) async {
    // App Service Notification in mobile notification area
    if (service is AndroidServiceInstance) {
      String now = DateTime.now().toString();
      String formattedDate = now.substring(0, now.length-1);

      service.setForegroundNotificationInfo(
        title: "HeartReader Background Service",
        content: "Last Cloud Upload at $formattedDate",
      );
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    debugPrint('background_service: -----------------------------------------------------------------------');
    /// you can see this log in logcat
    debugPrint('background_service: FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
    debugPrint('background_service: BLE device scan is starting in the background!');

    runBackgroundDeviceScan(); // background_ble_scan.dart
    /////////////////////////////////////////////////////////////////////////////////////////////////////////

    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}
