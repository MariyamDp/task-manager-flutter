import 'package:injectable/injectable.dart';

import '../repositories/task_repository.dart';

@injectable
class DeleteTaskUseCase {
  final ITaskRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<void> call(String id) => repository.deleteTask(id);
}
