import 'package:injectable/injectable.dart';

import '../../domain/entities/task.dart';
import 'i_task_data_source.dart';

@Environment('dev')
@LazySingleton(as: ITaskDataSource)
class InMemoryDataSource implements ITaskDataSource {
  final List<Task> _store = [];

  @override
  Future<List<Task>> getTasks() async => List.unmodifiable(_store);

  @override
  Future<void> saveTask(Task task) async {
    final idx = _store.indexWhere((t) => t.id == task.id);
    if (idx >= 0)
      _store[idx] = task;
    else
      _store.add(task);
  }

  @override
  Future<void> deleteTask(String id) async {
    _store.removeWhere((t) => t.id == id);
  }

  @override
  Future<void> markDone(String id, bool isDone) async {
    final idx = _store.indexWhere((t) => t.id == id);
    if (idx >= 0) {
      final t = _store[idx];
      _store[idx] = t.copyWith(isDone: isDone);
    }
  }

  @override
  Future<void> togglePin(String id) async {
    final idx = _store.indexWhere((t) => t.id == id);
    if (idx >= 0) {
      final t = _store[idx];
      _store[idx] = t.copyWith(isPinned: !t.isPinned);
    }
  }
}
