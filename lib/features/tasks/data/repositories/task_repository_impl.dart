import 'package:injectable/injectable.dart';

import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/i_task_data_source.dart';

@LazySingleton(as: ITaskRepository)
class TaskRepositoryImpl implements ITaskRepository {
  final ITaskDataSource dataSource;
  TaskRepositoryImpl(this.dataSource);

  @override
  Future<void> deleteTask(String id) => dataSource.deleteTask(id);

  @override
  Future<List<Task>> getTasks() async {
    final tasks = await dataSource.getTasks();
    // pinned-first, then by createdAt desc
    final list = List<Task>.from(tasks);
    list.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return list;
  }

  @override
  Future<void> saveTask(Task task) => dataSource.saveTask(task);

  @override
  Future<void> markDone(String id, bool isDone) =>
      dataSource.markDone(id, isDone);

  @override
  Future<void> togglePin(String id) => dataSource.togglePin(id);
}
