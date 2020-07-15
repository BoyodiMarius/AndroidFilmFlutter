import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'User.dart';

class MyDatabase {
  MyDatabase._privateConstructor();
  static final MyDatabase instance = MyDatabase._privateConstructor();
  static Database _database;

  static Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  static _initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      join(await getDatabasesPath(), 'movie_database.db'),
      onCreate: (db, version) {
         db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, firstName TEXT, lastName TEXT,"
              " userMail TEXT, password TEXT, photo TEXT)",
        );
         db.execute(
           "CREATE TABLE favoris(id INTEGER PRIMARY KEY AUTOINCREMENT,idUser INTEGER, idFilm INTEGER, titre TEXT, resume TEXT,"
               " acteurs TEXT, categories TEXT, photo TEXT, duree TEXT, dateSortie TEXT)",
         );
         return db;
      },
      version: 1,
    );
    return database;
  }

}
