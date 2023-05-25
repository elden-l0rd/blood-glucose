import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:max_heart_reader/user_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'globals.dart' as globals;
import 'find_devices.dart' as findDevicesWidget;
import 'package:excel/excel.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'data.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE graphData(
        timestamp STRING PRIMARY KEY,
        battery TEXT,
        heart_rate TEXT,
        spo2 TEXT,
        glucose_mmolL FLOAT,
        glucose_mgDL FLOAT,
        cholesterol TEXT,
        uaMen TEXT,
        uaWomen TEXT
      )
    ''');
  }

  Future<int> insertGraphData(graphData data) async {
    final db = await instance.database;
    return await db.insert('graphData', data.toMap());
  }

  // for graph plotting
  Future<List<graphData>> getGraphDataList() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('graphData');
    return List.generate(maps.length, (i) {
      return graphData(
        timestamp: maps[i]['timestamp'],  // 'dd/MM/yyyy HH:mm:ss'
        batteryText: maps[i]['battery'],
        heartRateText: maps[i]['heart_rate'],
        spo2Text: maps[i]['spo2'],
        glucose_mmolL: maps[i]['glucose_mmolL'],
        glucose_mgDL: maps[i]['glucose_mgDL'],
        cholesterolText: maps[i]['cholesterol'],
        UA_menText: maps[i]['uaMen'],
        UA_womenText: maps[i]['uaWomen'],
      );
    });
  }


  Future<List<Map<String, dynamic>>> getAllData() async {
    final databasePath = await getDatabasesPath();
    final database = await openDatabase(join(databasePath, 'data.db'));
    final result = await database.query('graphData');
    await database.close();
    return result;
  }

  void exportDataAsCSV(bool send_email, String email_add) async {
    final data = await getAllData();

    List<List<dynamic>> csvData = [];
    if (data.isNotEmpty) {
      // Extract column names from the first row
      final columnNames = data.first.keys.toList();
      csvData.add(columnNames);

      // Extract row data for each record
      for (final record in data) {
        final rowData = columnNames.map((columnName) => record[columnName]).toList();
        csvData.add(rowData);
      }
    }

    String csvContent = const ListToCsvConverter().convert(csvData);
      final file = await _localFile;
      await file.writeAsString(csvContent);
      
      if (send_email) {
        // Send email with attachment
        final Email emailer = Email(
          subject: 'CSV Data Export',
          recipients: [email_add],
          body: 'Please find attached the CSV data file.',
          attachmentPaths: [file.path], // Attach the XLS file
        );
        await FlutterEmailSender.send(emailer);
      }

      globals.toastMessage = 'CSV file saved successfully';
      findDevicesWidget.showToast();
  }

  void exportDataAsXLS(bool send_email, String email_add) async {
    final data = await getAllData();

    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    if (data.isNotEmpty) {
      // Extract column names from the first row
      final columnNames = data.first.keys.toList();
      sheet.appendRow(columnNames);

      // Extract row data for each record
      for (final record in data) {
        final rowData = columnNames.map((columnName) => record[columnName]).toList();
        sheet.appendRow(rowData);
      }
    }
    String formattedDateTime = DateFormat(globals.timeFormat).format(DateTime.now());
    String day = formattedDateTime.substring(0,2);
    String month = formattedDateTime.substring(3,5);
    String year = formattedDateTime.substring(6,10);
    String hour = formattedDateTime.substring(11,13);
    String minute = formattedDateTime.substring(14,16);
    String second = formattedDateTime.substring(17,19);

    final path = await _localPath;
    final file = File('$path/data_${day}_${month}_${year}_${hour}_${minute}_{$second}.xls');
    if (!await file.exists()) {
      file.create();
    }
    final excelBytes = excel.save()!; // Add null check here
    await file.writeAsBytes(List.from(excelBytes)); // Convert to non-nullable list

    if (send_email) {
    // Send email with attachment
    final Email emailer = Email(
      subject: 'XLS Data Export',
      recipients: [email_add],
      body: 'Please find attached the XLS data file.',
      attachmentPaths: [file.path], // Attach the XLS file
    );
    await FlutterEmailSender.send(emailer);
    }
    globals.toastMessage = 'XLS file saved successfully';
    // detailsScreen=null;
    findDevicesWidget.showToast();
  }

  // Get path of folder
  Future<String> get _localPath async {
    try {
      final directory = await getExternalStorageDirectory();
      return directory!.path;
    } catch (e) {
      debugPrint("Documents directory error...");
      return 'NULL';
    }
  }

  // Retrieve the file from path found
  Future<File> get _localFile async {
    String formattedDateTime = DateFormat(globals.timeFormat).format(DateTime.now());
    String day = formattedDateTime.substring(0,2);
    String month = formattedDateTime.substring(3,5);
    String year = formattedDateTime.substring(6,10);
    String hour = formattedDateTime.substring(11,13);
    String minute = formattedDateTime.substring(14,16);
    String second = formattedDateTime.substring(17,19);

    final path = await _localPath;
    final file = File('$path/data_${day}_${month}_${year}_${hour}_${minute}_$second.csv');
    if (!await file.exists()) {
      file.create();
    }
    // detailsScreen=null;
    return file;
  }

  Future<String?> getuserName() async {
    String? input_name = UserPreferences.getName();
    return input_name;
  }

}

class graphData {
  final String timestamp;
  final String batteryText;
  final String heartRateText;
  final String spo2Text;
  final double glucose_mmolL;
  final double glucose_mgDL;
  final String cholesterolText;
  final String UA_menText;
  final String UA_womenText;

  graphData(
    {required this.timestamp, 
      required this.batteryText,
      required this.heartRateText,
      required this.spo2Text,
      required this.glucose_mmolL,
      required this.glucose_mgDL,
      required this.cholesterolText,
      required this.UA_menText,
      required this.UA_womenText,
      });

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'battery': batteryText,
      'heart_rate': heartRateText,
      'spo2': spo2Text,
      'glucose_mmolL': glucose_mmolL,
      'glucose_mgDL': glucose_mgDL,
      'cholesterol': cholesterolText,
      'uaMen':  UA_menText,
      'uaWomen': UA_womenText,
    };
  }
}


// Hard coded data sets for testing!
// final List<graphData> data = [
//   graphData(
//     timestamp: DateTime.parse('2023-05-25 14:30:00'),
//     glucose_mmolL: 10,
//   ),
//   graphData(
//     timestamp: DateTime.parse('2023-05-26 15:45:00'),
//     glucose_mmolL: 20,
//   ),
//   graphData(
//     timestamp: DateTime.parse('2023-05-27 16:30:00'),
//     glucose_mmolL: 15,
//   ),
// ];

// DateTime currentDate = DateTime(2023, 5, 28); // Start date for generating additional data
// final random = Random();

// for (int i = 0; i < 20; i++) {
//   // Generate a random value for glucose_mmolL between 1 and 30
//   double glucoseValue = random.nextInt(30) + 1;

//   // Generate a random time within the current day
//   int randomHour = random.nextInt(24);
//   int randomMinute = random.nextInt(60);
//   int randomSecond = random.nextInt(60);
//   DateTime timestamp = DateTime(currentDate.year, currentDate.month, currentDate.day, randomHour, randomMinute, randomSecond);

//   // Create a new graphData object and add it to the data list
//   data.add(graphData(timestamp: timestamp, glucose_mmolL: glucoseValue));

//   // Increment the currentDate to the next day
//   currentDate = currentDate.add(Duration(days: 1));
// }
