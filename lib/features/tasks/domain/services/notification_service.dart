import 'package:injectable/injectable.dart';

import '../entities/task.dart';

@singleton
class NotificationService {
  Future<void> notifyTaskDeadline(Task task) async {
    // Integrate with local notifications or push in a real app.
  }
}

