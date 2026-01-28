import 'dart:ffi';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'milk.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        await database.execute("""
          CREATE TABLE IF NOT EXISTS milk_logs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT UNIQUE,
            bought INTEGER
          )
        """);
      },
    );
  }


  Future<void> saveLog(String date, int bought) async {
    final database = await db;

    await database.insert(
      "milk_logs",
      {
        "date": date,
        "bought": bought,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<Map<String, dynamic>>> getLogs() async {
    final database = await db;
    return database.query("milk_logs", orderBy: "date DESC");
  }


  Future<bool> hasLog(String date) async {
    final database = await db;

    final result = await database.query(
      "milk_logs",
      where: "date = ?",
      whereArgs: [date],
    );

    return result.isNotEmpty;
  }


  Future<void> autoFillYesterday() async {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));

    String yDate =
        "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";

    bool exists = await hasLog(yDate);

    if (!exists) {
      await saveLog(yDate, 0);
    }
  }


  Future<String> updatePrevious(String date ,int newBought) async {
    try{
    final database = await db;
    int result= await database.update("milk_logs", {
      'bought':newBought
    },
        where: 'date = ?',
    whereArgs: [date]);
    if(result >0) {
      return "Update done";
    }else {
      return "No date is found";
    }
  }catch(e) {
      return "invaild date $e";
    }
  }
  Future<void> deletedate() async
  {
    final database = await db;
    await database.delete("milk_logs");
  }



}
