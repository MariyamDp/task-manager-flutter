import '../entities/task.dart';

abstract class ITaskRepository {
  Future<List<Task>> getTasks();
  Future<void> saveTask(Task task);
  Future<void> deleteTask(String id);
  Future<void> togglePin(String id);
  Future<void> markDone(String id, bool isDone);
}
