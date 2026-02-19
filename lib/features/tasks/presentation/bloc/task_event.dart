import '../../domain/entities/task.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddOrUpdateTask extends TaskEvent {
  final Task task;

  AddOrUpdateTask(this.task);
}

class DeleteTask extends TaskEvent {
  final String id;

  DeleteTask(this.id);
}

class TogglePinTask extends TaskEvent {
  final String id;

  TogglePinTask(this.id);
}

class MarkTaskDone extends TaskEvent {
  final String id;
  final bool isDone;

  MarkTaskDone(this.id, this.isDone);
}

