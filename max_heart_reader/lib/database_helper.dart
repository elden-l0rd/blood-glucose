import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'globals.dart' as globals;
import 'find_devices.dart' as findDevicesWidget;
import 'package:excel/excel.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

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
        glucose FLOAT,
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
  // Future<List<graphData>> getGraphDataList() async {
  //   final db = await instance.database;
  //   final List<Map<String, dynamic>> maps = await db.query('graphData');
  //   return List.generate(maps.length, (i) {
  //     return graphData(
  //       timestamp: maps[i]['timestamp'],
  //       batteryText: maps[i]['battery'],
  //       heartRateText: maps[i]['heart_rate'],
  //       spo2Text: maps[i]['spo2'],
  //       glucose: maps[i]['glucose'],
  //       cholesterolText: maps[i]['cholesterol'],
  //       UA_menText: maps[i]['uaMen'],
  //       UA_womenText: maps[i]['uaWomen'],
  //     );
  //   });
  // }


  Future<List<Map<String, dynamic>>> getAllData() async {
    final databasePath = await getDatabasesPath();
    final database = await openDatabase(join(databasePath, 'data.db'));
    final result = await database.query('graphData');
    await database.close();
    return result;
  }

  void exportDataAsCSV(bool email) async {
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
      
      if (email) {
        // Send email with attachment
        final Email email = Email(
          subject: 'CSV Data Export',
          recipients: ['cfhuangx9@gmail.com'],
          body: 'Please find attached the CSV data file.',
          attachmentPaths: [file.path], // Attach the XLS file
        );
        await FlutterEmailSender.send(email);
      }


      globals.toastMessage = 'CSV file saved successfully';
      findDevicesWidget.showToast();
  }

  void exportDataAsXLS(bool email) async {
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

    final file = await _localFile;
    final excelBytes = excel.save()!; // Add null check here
    await file.writeAsBytes(List.from(excelBytes)); // Convert to non-nullable list

    if (email) {
    // Send email with attachment
    final Email email = Email(
      subject: 'XLS Data Export',
      recipients: ['cfhuangx9@gmail.com'],
      body: 'Please find attached the XLS data file.',
      attachmentPaths: [file.path], // Attach the XLS file
    );
    await FlutterEmailSender.send(email);
    }
    globals.toastMessage = 'XLS file saved successfully';
    findDevicesWidget.showToast();
  }

  // Get path of folder
  Future<String> get _localPath async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } catch (e) {
      debugPrint("Documents directory error...");
      return 'NULL';
    }
  }

  // Retrieve the file from path found
  Future<File> get _localFile async {
    final path = await _localPath;
    final file = File('$path/data.csv');
    if (!await file.exists()) {
      file.create();
    }
    return file;
  }

}

class graphData {
  final String timestamp;
  final String batteryText;
  final String heartRateText;
  final String spo2Text;
  final double glucose;
  final String cholesterolText;
  final String UA_menText;
  final String UA_womenText;

  graphData(
    {required this.timestamp, 
      required this.batteryText,
      required this.heartRateText,
      required this.spo2Text,
      required this.glucose,
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
      'glucose': glucose,
      'cholesterol': cholesterolText,
      'uaMen':  UA_menText,
      'uaWomen': UA_womenText,
    };
  }
}


