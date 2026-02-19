import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio();

  @preResolve
  @lazySingleton
  Future<SharedPreferences> get prefs async =>
      SharedPreferences.getInstance();

  @Environment('prod')
  @preResolve
  @lazySingleton
  Future<Database> get database async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            createdAt TEXT,
            deadline TEXT,
            isDone INTEGER,
            isPinned INTEGER,
            colorValue INTEGER
          )
        ''');
      },
    );
  }
}

