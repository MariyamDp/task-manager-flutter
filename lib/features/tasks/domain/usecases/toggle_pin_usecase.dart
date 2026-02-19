import 'package:injectable/injectable.dart';

import '../repositories/task_repository.dart';

@injectable
class TogglePinUseCase {
  final ITaskRepository repository;

  TogglePinUseCase(this.repository);

  Future<void> call(String id) => repository.togglePin(id);
}

