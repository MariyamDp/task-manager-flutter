import 'package:injectable/injectable.dart';

import '../entities/task.dart';

@singleton
class TaskReportGenerator {
  String generateSummary(List<Task> tasks) {
    final completed = tasks.where((t) => t.isDone).length;
    final pending = tasks.length - completed;
    return 'Completed: $completed, Pending: $pending';
  }
}

