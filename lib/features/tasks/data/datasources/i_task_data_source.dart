import '../../domain/entities/task.dart';

abstract class ITaskDataSource {
  Future<List<Task>> getTasks();
  Future<void> saveTask(Task task);
  Future<void> deleteTask(String id);
  Future<void> markDone(String id, bool isDone);
  Future<void> togglePin(String id);
}
