



import 'dart:async';

import 'package:floor/floor.dart';
import 'package:floor_database_todo_application/database/main_dao.dart';
import 'package:floor_database_todo_application/database/note_entity.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // will generated

@Database(version: 1, entities: [NoteEntity])
abstract class AppDatabase extends FloorDatabase {
  MainDao get mainDao;
}