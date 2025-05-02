import 'package:flutter_day5/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteController {
  static final SqliteController _singleton = SqliteController._internal();
  factory SqliteController()=> _singleton;
  SqliteController._internal();

Database? _database;

Future<Database> get database async {
  if (_database != null) return _database!;
  _database = await _initDB('notes.db');
  return _database!;
}

Future<Database> _initDB(String fileName) async {
  final path = join(await getDatabasesPath(),'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version){
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, discription TEXT)',
        );
      },
    );
  }

  //insert data
    Future<void>insert(Note note) async{
      final db = await database;
      await db.insert(
        'notes',
        note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    //get all notes
    Future<List<Note>> getAllNotes() async {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('notes');
      return List.generate(maps.length, (i) {
        return Note.fromMap(maps[i]);
      });
    }

    //update note
    Future<void> updateNote(Note note) async {
      final db = await database;
      await db.update(
        'notes',
        note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
      );
    }


    //delete note
    Future<void> deleteNote(int id) async {
      final db = await database;
      await db.delete(
        'notes',
        where: 'id = ?',
        whereArgs: [id],
      );
    }

  getNotes() {}

  delete(int? id) {}


}
  
