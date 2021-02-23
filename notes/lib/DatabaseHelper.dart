import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  static Database _database;
  static DatabaseHelper _databaseHelper; //SINGLETON DBHELPER
  DatabaseHelper._createInstance(); //NAMED CONST TO CREATE INSTANCE OF THE DBHELPER

  String noteTable = 'note_table';
  String colid = 'id';
  String colTitle = 'title';
  String colBody = 'body';
  String colKey = 'key';

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper =
          DatabaseHelper._createInstance(); //EXEC ONLY ONCE (SINGLETON OBJ)
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //GET THE PATH TO THE DIRECTORY FOR IOS AND ANDROID TO STORE DB
    String directory = await getDatabasesPath();

    String path = p.join(directory, "note.db");

    //OPEN/CREATE THE DB AT A GIVEN PATH
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);

    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colid INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colTitle TEXT,$colKey TEXT, $colBody TEXT) ');
  }

  //FETCH TO GET ALL NOTES
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = db.rawQuery("SELECT * FROM $noteTable ");
//    var result = await db.query(noteTable, orderBy: "$colPriority ASC");  //WORKS THE SAME CALLED HELPER FUNC
    return result;
  }

  //INSERT OPS
  Future<int> insertNote(Map<String, dynamic> row) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, row);
    return result;
  }

  //UPDATE OPS
  Future<int> updateNote(Map<String, dynamic> note) async {
    var db = await this.database;
    var result = await db
        .update(noteTable, note, where: '$colid = ?', whereArgs: [note['id']]);
    return result;
  }

  //DELETE OPS
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result =
        await db.delete(noteTable, where: "$colid = ?", whereArgs: [id]);
    return result;
  }

  //GET THE NO:OF NOTES
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT (*) FROM $noteTable");
    int result = Sqflite.firstIntValue(x);
    return result;
  }
}
