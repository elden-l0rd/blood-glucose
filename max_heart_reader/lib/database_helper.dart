import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

  Future<List<graphData>> getGraphDataList() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('graphData');
    return List.generate(maps.length, (i) {
      return graphData(
        timestamp: maps[i]['timestamp'],
        batteryText: maps[i]['battery'],
        heartRateText: maps[i]['heart_rate'],
        spo2Text: maps[i]['spo2'],
        glucose: maps[i]['glucose'],
        cholesterolText: maps[i]['cholesterol'],
        UA_menText: maps[i]['uaMen'],
        UA_womenText: maps[i]['uaWomen'],
      );
    });
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


