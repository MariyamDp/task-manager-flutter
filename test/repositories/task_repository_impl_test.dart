import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:db_task_manager/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:db_task_manager/features/tasks/data/datasources/i_task_data_source.dart';
import 'package:db_task_manager/features/tasks/domain/entities/task.dart';

class _MockDataSource extends Mock implements ITaskDataSource {}

void main() {
  late _MockDataSource mockDs;
  late TaskRepositoryImpl repo;

  setUp(() {
    mockDs = _MockDataSource();
    repo = TaskRepositoryImpl(mockDs);
  });

  test('getTasks returns pinned first then by createdAt desc', () async {
    final t1 = Task(
      id: '1',
      title: 'old',
      createdAt: DateTime(2020),
      isPinned: false,
    );
    final t2 = Task(
      id: '2',
      title: 'new',
      createdAt: DateTime(2022),
      isPinned: false,
    );
    final t3 = Task(
      id: '3',
      title: 'pinned',
      createdAt: DateTime(2021),
      isPinned: true,
    );

    when(() => mockDs.getTasks()).thenAnswer((_) async => [t1, t2, t3]);

    final res = await repo.getTasks();
    expect(res.first.id, '3'); // pinned first
    expect(res[1].id, '2'); // newest next
    expect(res[2].id, '1');
    verify(() => mockDs.getTasks()).called(1);
  });

  test('save/delete/markDone/togglePin delegate to datasource', () async {
    final t = Task(id: 'x', title: 'X');
    when(() => mockDs.saveTask(t)).thenAnswer((_) async {});
    when(() => mockDs.deleteTask('x')).thenAnswer((_) async {});
    when(() => mockDs.markDone('x', true)).thenAnswer((_) async {});
    when(() => mockDs.togglePin('x')).thenAnswer((_) async {});

    await repo.saveTask(t);
    await repo.deleteTask('x');
    await repo.markDone('x', true);
    await repo.togglePin('x');

    verify(() => mockDs.saveTask(t)).called(1);
    verify(() => mockDs.deleteTask('x')).called(1);
    verify(() => mockDs.markDone('x', true)).called(1);
    verify(() => mockDs.togglePin('x')).called(1);
  });
}
