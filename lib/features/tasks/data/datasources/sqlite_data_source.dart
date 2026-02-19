import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/entities/task.dart';
import '../models/task_model.dart';
import 'task_data_source.dart';

@Environment('prod')
@LazySingleton(as: ITaskDataSource)
class SQLiteDataSource implements ITaskDataSource {
  final Database _db;

  SQLiteDataSource(this._db);

  @override
  Future<void> delete(String id) async {
    await _db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Task>> readAll() async {
    final maps = await _db.query('tasks');
    return maps
        .map(
          (e) => TaskModel.fromJson(e),
        )
        .toList();
  }

  @override
  Future<void> save(Task item) async {
    final model = TaskModel.fromTask(item);
    await _db.insert(
      'tasks',
      {
        ...model.toJson(),
        'isDone': model.isDone ? 1 : 0,
        'isPinned': model.isPinned ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> markDone(String id, bool isDone) async {
    await _db.update(
      'tasks',
      {'isDone': isDone ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> togglePin(String id) async {
    final maps =
        await _db.query('tasks', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return;
    final task = TaskModel.fromJson(maps.first);
    await _db.update(
      'tasks',
      {'isPinned': task.isPinned ? 0 : 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

