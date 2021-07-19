
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/model/note.dart';

class NotesDatabase {

  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database?> get  database  async {
    // if database is already there then return else create new one;
    if(_database != null ) return _database;

    _database = await _initDB("note.db");

    return _database!;
}

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _create);
  }


  FutureOr<void> _create(Database db, int version) async {

    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute(''' 
    CREATE TABLE $tableName (
     ${NotesFields.id} $idType,
     ${NotesFields.title} $textType,
     ${NotesFields.description} $textType,
     ${NotesFields.time} $textType    
   )
    ''');
  }


  Future<Note> create(Note note) async {
    final db = await instance.database;

    final id  = await db!.insert(tableName, note.toJson());

    // it will return and modify only notes id
    return note.copy(id:id);
  }


  // reading one note
  Future<Note?> readNote(int id) async {
    final db = await instance.database;
    final maps = await db!.query(
        tableName,
        columns: NotesFields.values,
      where: '${NotesFields.id}  = ? ',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }


  // reading all notes
  Future<List<Note>> readAllNotes()  async {
    final db = await instance.database;
    final orderBy = "${NotesFields.time} ASC";

    final result = await db!.query(tableName, orderBy: orderBy);
    return result.map((j) => Note.fromJson(j)).toList();
  }


  Future<int> update(Note note) async {

    final db = await instance.database;

    final result  = await db!.update(tableName,
        note.toJson(),
        where: "${NotesFields.id} = ? ",
        whereArgs: [note.id],
    );
    return result;
  }


  Future<int> delete(int id) async {

    final db = await instance.database;
    return db!.delete(tableName,
        where:"${NotesFields.id} = ? ",
        whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await instance.database;
    db!.close();

  }

}