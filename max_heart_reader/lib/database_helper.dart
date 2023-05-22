// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._();

//   static Database? _database;

//   DatabaseHelper._();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     final path = join(await getDatabasesPath(), 'data.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _createDB,
//     );
//   }

//   Future<void> _createDB(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE personalInfo(
//         name STRING PRIMARY KEY,
//         age TEXT,
//         gender TEXT,
//         height TEXT,
//         weight FLOAT,
//       )
//     ''');
//   }

//   Future<int> insertGraphData(personalInfo data) async {
//     final db = await instance.database;
//     return await db.insert('personalInfo', data.toMap());
//   }

//   Future<List<personalInfo>> getGraphDataList() async {
//     final db = await instance.database;
//     final List<Map<String, dynamic>> maps = await db.query('personalInfo');
//     return List.generate(maps.length, (i) {
//       return personalInfo(
//         name: maps[i]['name'],
//         age: maps[i]['age'],
//         gender: maps[i]['gender'],
//         height: maps[i]['height'],
//         weight: maps[i]['weight'],
//       );
//     });
//   }
// }

// class personalInfo{
//   final String name;
//   final String age;
//   final String gender;
//   final String height;
//   final double weight;

//   personalInfo(
//     {required this.name, 
//       required this.age,
//       required this.gender,
//       required this.height,
//       required this.weight,
//     });

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'age': age,
//       'gender': gender,
//       'height': height,
//       'weight': weight,
//     };
//   }
// }


