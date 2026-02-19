import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:db_task_manager/features/tasks/domain/entities/task.dart';
import 'package:db_task_manager/features/tasks/domain/repositories/task_repository.dart';
import 'package:db_task_manager/features/tasks/domain/usecases/get_tasks_usecase.dart';

class _MockTaskRepository extends Mock implements ITaskRepository {}

void main() {
  late _MockTaskRepository mockRepo;
  late GetTasksUseCase useCase;

  setUp(() {
    mockRepo = _MockTaskRepository();
    useCase = GetTasksUseCase(mockRepo);
  });

  test('should get tasks from repository', () async {
    final tTask = Task(
      id: '1',
      title: 'Test',
      description: 'desc',
      createdAt: DateTime.now(),
    );

    when(() => mockRepo.getTasks()).thenAnswer((_) async => [tTask]);

    final result = await useCase();

    expect(result, isA<List<Task>>());
    expect(result.length, 1);
    verify(() => mockRepo.getTasks()).called(1);
  });
}
