import 'package:flutter/material.dart';
import 'package:max_heart_reader/main.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Server/src/Background service/background_service.dart';
import '../utils/globals.dart' as globals; // Global variables
import '../Server/src/find_devices.dart' as findDevicesWidget; // to display Toast notification


// Granted -> true
Future<bool> checkPermissionStatus(Permission permission) async {
  await permission.request();
  return (await permission.isGranted) ? true: false;
}

Future<void> getPermissions(context) async {
  // null when it was not initialized, false if not granted, true if granted access
  var locationWhenInUseStatus = await checkPermissionStatus(Permission.locationWhenInUse);
  var locationAlwaysStatus = await checkPermissionStatus(Permission.locationAlways);
  var bluetoothStatus = await checkPermissionStatus(Permission.bluetooth);
  var bluetoothScanStatus = await checkPermissionStatus(Permission.bluetoothScan);
  var bluetoothAdvertiseStatus = await checkPermissionStatus(Permission.bluetoothAdvertise);
  var bluetoothConnectStatus = await checkPermissionStatus(Permission.bluetoothConnect);
  var batteryOptimizationsStatus = await checkPermissionStatus(Permission.ignoreBatteryOptimizations);
  var pushNotificationsPermission = await checkPermissionStatus(Permission.notification);
  var storageAccessPermission = await checkPermissionStatus(Permission.storage);

  debugPrint('main.dart: checkPermissions [locationWhenInUseStatus = $locationWhenInUseStatus]');
  debugPrint('main.dart: checkPermissions [locationAlwaysStatus = $locationAlwaysStatus]');
  debugPrint('main.dart: checkPermissions [bluetoothStatus = $bluetoothStatus]');
  debugPrint('main.dart: checkPermissions [bluetoothScanStatus = $bluetoothScanStatus]');
  debugPrint('main.dart: checkPermissions [bluetoothAdvertiseStatus = $bluetoothAdvertiseStatus]');
  debugPrint('main.dart: checkPermissions [bluetoothConnectStatus = $bluetoothConnectStatus]');
  debugPrint('main.dart: checkPermissions [batteryOptimizationsStatus = $batteryOptimizationsStatus]');
  debugPrint('main.dart: checkPermissions [pushNotificationsPermission = $pushNotificationsPermission]');
  debugPrint('main.dart: checkPermissions [storageAccessPermission = $storageAccessPermission]');

  // if the user enables permissions successfully
  if (locationWhenInUseStatus && locationAlwaysStatus) {
    // start Background Service
    debugPrint('main.dart: checkPermissions initializing background service');
    await initializeService();

    globals.toastMessage = 'All Permissions Were Enabled Successfully!';
    findDevicesWidget.showToast();

    // go to the next widget: HomeScreen -> bluetooth_off_screen.dart OR find_devices.dart
    debugPrint('main.dart: checkPermissions opening HomeScreen in 2 seconds');
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    });


  } else {  // if the user denies permissions
    debugPrint('main.dart: checkPermissions Error! Some permissions were denied!');
    globals.toastMessage = 'Permissions Were Not Enabled!\nPlease Enable in Settings';
    findDevicesWidget.showToast();

    openAppSettings();
  }
}
