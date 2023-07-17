import 'package:flutter/material.dart';
import 'package:max_heart_reader/main.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Server/src/Background service/background_service.dart';
import '../../globals.dart' as globals; // Global variables
import '../../Server/src/find_devices.dart'
    as findDevicesWidget; // to display Toast notification

Future<void> getPermissions(context) async {
  (await getLocationWhenInUsePermission()==1)
    ? debugPrint('main.dart: getLocationWhenInUsePermission SUCCESS!')
    : debugPrint('main.dart: getLocationWhenInUsePermission waiting for permission!');

  (await getLocationAlwaysPermission() == 1) 
    ? debugPrint('main.dart: getLocationAlwaysPermission SUCCESS!')
    : debugPrint('main.dart: getLocationAlwaysPermission waiting for permission!');
  
  (await getIgnoreBatteryOptimizationPermission() == 1) 
    ?  debugPrint('main.dart: getIgnoreBatteryOptimizationPermission SUCCESS!')
    :  debugPrint('main.dart: getIgnoreBatteryOptimizationPermission waiting for permission!');

  (await getPushNotificationsPermission() == 1)
    ?  debugPrint('main.dart: getPushNotificationsPermission SUCCESS!')
    :  debugPrint('main.dart: getPushNotificationsPermission waiting for permission!');

  checkPermissions(context);
}

// Granted -> return 1
// Restricted or Denied -> return 0
Future<int> getLocationWhenInUsePermission() async {
  // [WHILE USING THE APP / ONLY THIS TIME / DENY]
  await Permission.locationWhenInUse.request();
  return (await Permission.locationWhenInUse.request().isGranted) ? 1 : 0;
}

Future<int> getLocationAlwaysPermission() async {
  // [ALLOW ALL THE TIME / ALLOW ONLY WHILE USING THE APP / ASK EVERY TIME / DENY]
  await Permission.locationAlways.request();
  return (await Permission.locationAlways.request().isGranted) ? 1 : 0;
}

Future<int> getIgnoreBatteryOptimizationPermission() async {
  // [ALLOW / DENY]
  await Permission.ignoreBatteryOptimizations.request();
  return (await Permission.ignoreBatteryOptimizations.request().isGranted) ? 1 : 0;
}

Future<int> getPushNotificationsPermission() async {
  // [ALLOW / DENY]
  await Permission.notification.request();
  return (await Permission.notification.request().isGranted) ? 1 : 0;
}

Future<void> checkPermissions(context) async {
  // null when it was not initialized, false if not granted, true if granted access
  var locationWhenInUseStatus = await Permission.locationWhenInUse.status.isGranted;
  var locationAlwaysStatus = await Permission.locationAlways.status.isGranted;
  var bluetoothStatus = await Permission.bluetooth.status.isGranted;
  var bluetoothScanStatus = await Permission.bluetoothScan.status.isGranted;
  var bluetoothAdvertiseStatus = await Permission.bluetoothAdvertise.status.isGranted;
  var bluetoothConnectStatus = await Permission.bluetoothConnect.status.isGranted;
  var batteryOptimizationsStatus = await Permission.ignoreBatteryOptimizations.status.isGranted;
  var pushNotificationsPermission = await Permission.notification.isGranted;

  debugPrint('main.dart: checkPermissions [locationWhenInUseStatus = $locationWhenInUseStatus]');
  debugPrint('main.dart: checkPermissions [locationAlwaysStatus = $locationAlwaysStatus]');
  debugPrint('main.dart: checkPermissions [bluetoothStatus = $bluetoothStatus]');
  debugPrint('main.dart: checkPermissions [bluetoothScanStatus = $bluetoothScanStatus]');
  debugPrint('main.dart: checkPermissions [bluetoothAdvertiseStatus = $bluetoothAdvertiseStatus]');
  debugPrint('main.dart: checkPermissions [bluetoothConnectStatus = $bluetoothConnectStatus]');
  debugPrint('main.dart: checkPermissions [batteryOptimizationsStatus = $batteryOptimizationsStatus]');
  debugPrint('main.dart: checkPermissions [pushNotificationsPermission = $pushNotificationsPermission]');

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
