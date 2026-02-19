import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:db_task_manager/features/tasks/domain/entities/task.dart';
import 'package:db_task_manager/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:db_task_manager/features/tasks/presentation/bloc/task_event.dart';
import 'package:db_task_manager/features/tasks/presentation/bloc/task_state.dart';
import 'package:db_task_manager/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:db_task_manager/features/tasks/domain/usecases/save_task_usecase.dart';
import 'package:db_task_manager/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:db_task_manager/features/tasks/domain/usecases/toggle_pin_usecase.dart';
import 'package:db_task_manager/features/tasks/domain/usecases/mark_done_usecase.dart';
import 'package:db_task_manager/features/tasks/domain/services/task_validator.dart';

class _MockGetTasks extends Mock implements GetTasksUseCase {}

class _MockSaveTask extends Mock implements SaveTaskUseCase {}

class _MockDeleteTask extends Mock implements DeleteTaskUseCase {}

class _MockTogglePin extends Mock implements TogglePinUseCase {}

class _MockMarkDone extends Mock implements MarkDoneUseCase {}

class _MockValidator extends Mock implements TaskValidator {}

void main() {
  late _MockGetTasks getTasks;
  late _MockSaveTask saveTask;
  late _MockDeleteTask deleteTask;
  late _MockTogglePin togglePin;
  late _MockMarkDone markDone;
  late _MockValidator validator;
  late TaskBloc bloc;

  setUp(() {
    getTasks = _MockGetTasks();
    saveTask = _MockSaveTask();
    deleteTask = _MockDeleteTask();
    togglePin = _MockTogglePin();
    markDone = _MockMarkDone();
    validator = _MockValidator();

    bloc = TaskBloc(
      getTasks,
      saveTask,
      deleteTask,
      togglePin,
      markDone,
      validator,
    );
  });

  tearDown(() {
    bloc.close();
  });

  blocTest<TaskBloc, TaskState>(
    'emits [TaskLoading, TaskLoaded] when LoadTasks is added',
    build: () {
      when(() => getTasks()).thenAnswer((_) async => <Task>[]);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTasks()),
    expect: () => [isA<TaskLoading>(), isA<TaskLoaded>()],
  );
}
