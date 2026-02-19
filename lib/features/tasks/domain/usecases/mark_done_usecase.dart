import 'package:injectable/injectable.dart';

import '../repositories/task_repository.dart';

@injectable
class MarkDoneUseCase {
  final ITaskRepository repository;

  MarkDoneUseCase(this.repository);

  Future<void> call(String id, bool isDone) =>
      repository.markDone(id, isDone);
}

