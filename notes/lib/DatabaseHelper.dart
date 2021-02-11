import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static final _dbName = 'localNotesDB.db';
  static final _dbVersion = 1;
  static final _tableName = 'NotesTable';
  static final _columnID = "_id";
  static final columnKey = 'key';
  static final columnTitle = 'Title';
  static final columnBody = 'Body';
  //Converting to Singleton Class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    return db.execute('''
          CREATE TABLE $_tableName ($_columnID INTEGER PRIMARY KEY,
          $columnKey TEXT,$columnTitle TEXT,$columnBody TEXT)
        ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['columnID'];
    return await db
        .update(_tableName, row, where: '$_columnID=?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$_columnID=?', whereArgs: [id]);
  }
}
