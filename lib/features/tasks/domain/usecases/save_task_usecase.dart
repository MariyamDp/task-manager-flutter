import 'package:injectable/injectable.dart';

import '../entities/task.dart';
import '../repositories/task_repository.dart';

@injectable
class SaveTaskUseCase {
  final ITaskRepository repository;

  SaveTaskUseCase(this.repository);

  Future<void> call(Task task) => repository.saveTask(task);
}
