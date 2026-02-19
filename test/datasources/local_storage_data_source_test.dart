import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:db_task_manager/features/tasks/data/datasources/local_storage_data_source.dart';
import 'package:db_task_manager/features/tasks/domain/entities/task.dart';

void main() {
  group('LocalStorageDataSource', () {
    late LocalStorageDataSource ds;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      ds = LocalStorageDataSource(prefs);
    });

    test('save and readAll', () async {
      final t1 = Task(id: '1', title: 'Test', description: 'Desc');
      await ds.save(t1);
      final list = await ds.readAll();
      expect(list.length, 1);
      expect(list.first.id, '1');
      expect(list.first.title, 'Test');
    });

    test('delete removes task', () async {
      final t1 = Task(id: 'del1', title: 'ToDelete', description: '');
      await ds.save(t1);
      expect((await ds.readAll()).any((t) => t.id == 'del1'), isTrue);
      await ds.delete('del1');
      expect((await ds.readAll()).any((t) => t.id == 'del1'), isFalse);
    });

    test('markDone updates isDone field', () async {
      final t1 = Task(
        id: 'mark1',
        title: 'MarkTest',
        description: '',
        isDone: false,
      );
      await ds.save(t1);
      await ds.markDone('mark1', true);
      final all = await ds.readAll();
      final updated = all.firstWhere((t) => t.id == 'mark1');
      expect(updated.isDone, isTrue);
    });

    test('togglePin updates isPinned field', () async {
      final t1 = Task(
        id: 'pin1',
        title: 'PinTest',
        description: '',
        isPinned: false,
      );
      await ds.save(t1);
      await ds.togglePin('pin1');
      final all = await ds.readAll();
      final updated = all.firstWhere((t) => t.id == 'pin1');
      expect(updated.isPinned, isTrue);
    });
  });
}
