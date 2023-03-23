import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:flutter_crud_sqlite/models/Notes.dart';

class DatabaseHelper{
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(createNotes);
  }

  Future<Database?> _initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'notes.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<Database?> getDatabase()  async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDb();
    return _database;
  }


  late String tableNotes = 'notes';
  late String idNotes = 'id';
  late String titleNotes = 'title';
  late String descNotes = 'desc';
  late String tanggalNotes = 'tanggal';

  late String createNotes = "CREATE TABLE $tableNotes($idNotes INTEGER PRIMARY KEY, "
      "$titleNotes TEXT,"
      "$descNotes TEXT,"
      "$tanggalNotes DATETIME)";

  Future<List?> getAllNotes() async {
    var dbClient = await DatabaseHelper().getDatabase();
    var result = await dbClient!.query(tableNotes, columns: [
      idNotes,
      titleNotes,
      descNotes,
      tanggalNotes
    ]);

    return result.toList();
  }

  Future<int?> saveNotes(Notes notes) async {
    var dbClient = await DatabaseHelper().getDatabase();
    return await dbClient!.insert(tableNotes, notes.toMap());
  }


  Future<int?> updateNotes(Notes notes) async {
    var dbClient = await DatabaseHelper().getDatabase();
    return await dbClient!.update(tableNotes, notes.toMap(), where: '$idNotes = ?', whereArgs: [notes.id]);
  }

  Future<int?> deleteNotes(int id) async {
    var dbClient = await DatabaseHelper().getDatabase();
    return await dbClient!.delete(tableNotes, where: '$idNotes = ?', whereArgs: [id]);
  }


}