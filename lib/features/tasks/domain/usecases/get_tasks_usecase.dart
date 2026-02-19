import 'package:injectable/injectable.dart';
import '../repositories/task_repository.dart';
import '../entities/task.dart';

@injectable
class GetTasksUseCase {
  final ITaskRepository repository;
  GetTasksUseCase(this.repository);

  Future<List<Task>> call() => repository.getTasks();
}
