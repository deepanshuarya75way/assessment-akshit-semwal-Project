import 'package:hrapp/Services/Connection_check.dart';
import 'package:hrapp/Services/location_service.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'Rs-hrms.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE IF NOT EXISTS EmployeeLocationLogs (
          Id INTEGER PRIMARY KEY AUTOINCREMENT,
          EmployeeId INTEGER NOT NULL,
          DeviceId TEXT NOT NULL,
          Latitude REAL NOT NULL,
          Longitude REAL NOT NULL,
          Accuracy REAL,
          RecordedAt TEXT NOT NULL,
          ReceivedAt TEXT,
          Source TEXT,
          CreatedAt TEXT,
          issync INTEGER DEFAULT 0
        )
      ''');
      },
    );
  }

  Future<int?> insertLocation(Map<String, dynamic> data) async {
    try {
      final db = await AppDatabase.database;

      return await db.insert(
        'EmployeeLocationLogs',
        data,
      );
    } catch (e) {
      print("Insert Error: $e");
      return null;
    }
  }

  bool _isSyncing = false;

  Future<void> unsyncDataToServer() async {
    if (_isSyncing) {
      print("⛔ Sync already running");
      return;
    }

    _isSyncing = true;

    try {
      bool isOnline = await ConnectionCheck.isOnline();
      if (!isOnline) {
        print("🌐 No internet");
        return;
      }

      final db = await AppDatabase.database;

      List<Map<String, dynamic>> unsyncedData = await db.query(
        "EmployeeLocationLogs",
        where: "issync = ?",
        whereArgs: [0],
      );

      print("📦 Unsynced rows: ${unsyncedData.length}");

      if (unsyncedData.isEmpty) {
        print("✅ Nothing to sync");
        return;
      }

      bool isSuccess = await sendLocation(unsyncedData);

      if (isSuccess) {
        await db.rawUpdate(
          "UPDATE EmployeeLocationLogs SET issync = 1 WHERE issync = 0",
        );
        print("✅ Sync completed");
      }
    } catch (e, s) {
      print("❌ Sync error: $e");
    } finally {
      _isSyncing = false; // 🔓 ALWAYS RESET
    }
  }

  Future<void> syncDataToServer() async {
    final db = await AppDatabase.database;

    // Step 1: Get unsynced data
    List<Map<String, dynamic>> unsyncedData = await db.query(
      "EmployeeLocationLogs",
      where: "issync = ?",
      whereArgs: [1],
    );

    if (unsyncedData.isEmpty) {
      print("No data to sync");
      return;
    }
    print(unsyncedData.toList().length.toString());
    // print(unsyncedData.toList().toString());
    // print("Sending ${unsyncedData.length} records to server...");
  }

  Future<void> printAllData() async {
    final db = await AppDatabase.database;

    var result = await db.query('EmployeeLocationLogs');

    print(result);
  }

  Future<void> printDbPath() async {
    final dbPath = await getDatabasesPath();
    print("DB PATH: $dbPath");
  }

  Future<void> DataCount() async {
    final db = await AppDatabase.database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM EmployeeLocationLogs'),
    );

    print("Row count: $count");
  }
}
