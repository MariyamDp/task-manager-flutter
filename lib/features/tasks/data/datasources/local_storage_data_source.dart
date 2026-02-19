import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/task.dart';
import '../models/task_model.dart';
import 'task_data_source.dart';

const _tasksKey = 'tasks';

@Environment('dev')
@LazySingleton(as: ITaskDataSource)
class LocalStorageDataSource implements ITaskDataSource {
  final SharedPreferences _prefs;

  LocalStorageDataSource(this._prefs);

  List<TaskModel> _decodeTasks() {
    final jsonString = _prefs.getString(_tasksKey);
    if (jsonString == null) return [];
    final list = json.decode(jsonString) as List<dynamic>;
    return list
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _persistTasks(List<TaskModel> tasks) async {
    final jsonString =
        json.encode(tasks.map((e) => e.toJson()).toList());
    await _prefs.setString(_tasksKey, jsonString);
  }

  @override
  Future<void> delete(String id) async {
    final tasks = _decodeTasks();
    tasks.removeWhere((t) => t.id == id);
    await _persistTasks(tasks);
  }

  @override
  Future<List<Task>> readAll() async {
    return _decodeTasks();
  }

  @override
  Future<void> save(Task item) async {
    final tasks = _decodeTasks();
    final index = tasks.indexWhere((t) => t.id == item.id);
    final model = TaskModel.fromTask(item);
    if (index >= 0) {
      tasks[index] = model;
    } else {
      tasks.add(model);
    }
    await _persistTasks(tasks);
  }

  @override
  Future<void> markDone(String id, bool isDone) async {
    final tasks = _decodeTasks();
    final index = tasks.indexWhere((t) => t.id == id);
    if (index >= 0) {
      final task = tasks[index];
      tasks[index] = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        createdAt: task.createdAt,
        deadline: task.deadline,
        isDone: isDone,
        isPinned: task.isPinned,
        color: task.color,
      );
      await _persistTasks(tasks);
    }
  }

  @override
  Future<void> togglePin(String id) async {
    final tasks = _decodeTasks();
    final index = tasks.indexWhere((t) => t.id == id);
    if (index >= 0) {
      final task = tasks[index];
      tasks[index] = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        createdAt: task.createdAt,
        deadline: task.deadline,
        isDone: task.isDone,
        isPinned: !task.isPinned,
        color: task.color,
      );
      await _persistTasks(tasks);
    }
  }
}

