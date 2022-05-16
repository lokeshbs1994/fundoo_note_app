import 'dart:io';

import 'package:instagram_flutter/model/note.dart';
import 'package:instagram_flutter/resources/note_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SqlFliteManager {
  static final _dbName = 'newNotesDatabase2.db';
  static final _dbVersion = 1;
  static final _tableName = 'Notes';

  //static final columnCreatedAt = 'createdAt';

  SqlFliteManager._internal();
  static final SqlFliteManager _singleton = SqlFliteManager._internal();
  //factory SqlFliteManager() => _singleton;
  static SqlFliteManager getInstance() => _singleton;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initiateDatabase();
    return _database!;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    return db.execute('''
      CREATE TABLE $_tableName(
        ${NoteFields.id} TEXT NOT NULL,
      ${NoteFields.title} TEXT NOT NULL,
      ${NoteFields.content} TEXT NOT NULL,
      ${NoteFields.createdAt} TEXT NOT NULL,
      ${NoteFields.isArchive} BOOLEAN NOT NULL )
      ''');
  }

  Future<int> insertNewNote({
    required Note note,
  }) async {
    Database db = await SqlFliteManager.getInstance().database;

    // final json = note.toSqJson();
    // final columns =
    //     '${NoteFields.id},${NoteFields.title}, ${NoteFields.content}, ${NoteFields.createdAt}';
    // final values =
    //     '${json[NoteFields.id]},${json[NoteFields.title]}, ${json[NoteFields.content]}, ${json[NoteFields.createdAt]}';
    // final id = await db
    //     .rawInsert('INSERT INTO $_tableName ($columns) VALUES ($values)');
    // return id;
    return await db.insert(_tableName, note.toSqJson());
  }

  Future<int> update(
      {required String id,
      required String title,
      required String content}) async {
    Database db = await SqlFliteManager.getInstance().database;

    return await db.update(
        _tableName,
        {
          NoteFields.title: title,
          NoteFields.content: content,
        },
        where: '${NoteFields.id} = ?',
        whereArgs: [id]);
  }

  Future archNote(Note note) async {
    final db = await SqlFliteManager.getInstance().database;

    await db.update(_tableName, {NoteFields.isArchive: !note.isArchive ? 1 : 0},
        where: '${NoteFields.id} = ?', whereArgs: [note.id]);
  }

  Future<int> delete(String id) async {
    Database db = await SqlFliteManager.getInstance().database;
    return await db
        .delete(_tableName, where: '${NoteFields.id} = ?', whereArgs: [id]);
  }

  Future<Note> readNote(String id) async {
    final db = await SqlFliteManager.getInstance().database;

    final maps = await db.query(
      _tableName,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromSqJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Map<String, Object?>>> readAllNotes() async {
    final db = await SqlFliteManager.getInstance().database;

    final orderBy = '${NoteFields.createdAt} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(_tableName, orderBy: orderBy);
    return result;
    //return result.map((json) => Note.fromSqJson(json)).toList();
  }
}
