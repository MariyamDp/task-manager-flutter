import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/task.dart';
import '../../domain/services/task_validator.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/mark_done_usecase.dart';
import '../../domain/usecases/save_task_usecase.dart';
import '../../domain/usecases/toggle_pin_usecase.dart';
import 'task_event.dart';
import 'task_state.dart';

@injectable
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUseCase _getTasks;
  final SaveTaskUseCase _saveTask;
  final DeleteTaskUseCase _deleteTask;
  final TogglePinUseCase _togglePin;
  final MarkDoneUseCase _markDone;
  final TaskValidator _validator;

  TaskBloc(
    this._getTasks,
    this._saveTask,
    this._deleteTask,
    this._togglePin,
    this._markDone,
    this._validator,
  ) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddOrUpdateTask>(_onAddOrUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<TogglePinTask>(_onTogglePinTask);
    on<MarkTaskDone>(_onMarkTaskDone);
  }

  Future<void> _onLoadTasks(
    LoadTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final tasks = await _getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddOrUpdateTask(
    AddOrUpdateTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      _validator.validate(event.task);
      await _saveTask(event.task);
      final tasks = await _getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _deleteTask(event.id);
      final tasks = await _getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onTogglePinTask(
    TogglePinTask event,
    Emitter<TaskState> emit,
  ) async {
    await _togglePin(event.id);
    final tasks = await _getTasks();
    emit(TaskLoaded(tasks));
  }

  Future<void> _onMarkTaskDone(
    MarkTaskDone event,
    Emitter<TaskState> emit,
  ) async {
    await _markDone(event.id, event.isDone);
    final tasks = await _getTasks();
    emit(TaskLoaded(tasks));
  }
}

