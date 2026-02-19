import 'package:injectable/injectable.dart';

import '../entities/task.dart';

@singleton
class TaskValidator {
  void validate(Task task) {
    if (task.title.trim().isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }
    if (task.deadline != null &&
        task.deadline!.isBefore(task.createdAt)) {
      throw ArgumentError('Deadline must be after created date');
    }
  }
}

