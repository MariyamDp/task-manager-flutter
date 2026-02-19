import '../../../../core/interfaces/storage_interfaces.dart';
import '../../domain/entities/task.dart';

abstract class ITaskDataSource
    implements Readable<Task>, Writable<Task>, Deletable<Task> {
  Future<void> togglePin(String id);
  Future<void> markDone(String id, bool isDone);
}

