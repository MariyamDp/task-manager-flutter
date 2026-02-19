import 'package:flutter_test/flutter_test.dart';
import 'package:db_task_manager/features/tasks/data/datasources/in_memory_data_source.dart';
import 'package:db_task_manager/features/tasks/domain/entities/task.dart';

void main() {
  group('InMemoryDataSource', () {
    late InMemoryDataSource ds;

    setUp(() {
      ds = InMemoryDataSource();
    });

    test('saveTask and getTasks', () async {
      final t1 = Task(id: '1', title: 'A');
      await ds.saveTask(t1);
      final list = await ds.getTasks();
      expect(list.length, 1);
      expect(list.first.id, '1');
    });

    test('deleteTask removes item', () async {
      final t1 = Task(id: 'del', title: 'Del');
      await ds.saveTask(t1);
      expect((await ds.getTasks()).any((t) => t.id == 'del'), isTrue);
      await ds.deleteTask('del');
      expect((await ds.getTasks()).any((t) => t.id == 'del'), isFalse);
    });

    test('markDone and togglePin update fields', () async {
      final t = Task(id: 'm1', title: 'M', isDone: false, isPinned: false);
      await ds.saveTask(t);
      await ds.markDone('m1', true);
      final afterDone = (await ds.getTasks()).firstWhere((x) => x.id == 'm1');
      expect(afterDone.isDone, isTrue);

      await ds.togglePin('m1');
      final afterPin = (await ds.getTasks()).firstWhere((x) => x.id == 'm1');
      expect(afterPin.isPinned, isTrue);
    });
  });
}
