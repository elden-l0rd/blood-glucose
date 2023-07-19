// Trilogy Technologies
// Project: Smart Wearable v4
// Project done by Chu Feng (under Christopher Ng)
// Tested and Working on OnePlus Nord CE [ANDROID] device
// This will not work on an emulator as it will not find any bluetooth devices

// Main dart/flutter libraries
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:max_heart_reader/Client/src/LandingPage/user_preferences.dart';
import 'package:max_heart_reader/Client/permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
// Project files
import 'Server/src/Background service/bluetooth_off_screen.dart'; // 1st screen of the app (bluetooth off)
// 2nd screen of the app (find devices)
import 'Server/src/Background service/background_ble_scan.dart' as background1;
// BLE
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'Client/src/LandingPage/landing_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


Timer mytimer = Timer.periodic(Duration(seconds: 5), (timer) {
  background1.runBackgroundDeviceScan();
});

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _HomeScreenState state = context.findAncestorStateOfType<_HomeScreenState>()!;
    state.setLocale(newLocale);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
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