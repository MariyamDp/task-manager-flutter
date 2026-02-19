import 'package:flutter_test/flutter_test.dart';
import 'package:db_task_manager/features/tasks/domain/entities/task.dart';

void main() {
  group('Task Entity', () {
    test('Task can be created with defaults', () {
      final t = Task(id: 'id1', title: 'Title');
      expect(t.id, 'id1');
      expect(t.title, 'Title');
      expect(t.description, '');
      expect(t.isDone, isFalse);
      expect(t.isPinned, isFalse);
    });

    test('RecurringTask extends Task (LSP)', () {
      final rt = RecurringTask(
        id: 'r1',
        title: 'Recurring',
        description: 'Weekly task',
        recurrence: Duration(days: 7),
      );
      expect(rt, isA<Task>());
      expect(rt.id, 'r1');
      expect(rt.title, 'Recurring');
      expect(rt.recurrence, Duration(days: 7));
    });

    test('PriorityTask extends Task (LSP)', () {
      final pt = PriorityTask(
        id: 'p1',
        title: 'High Priority',
        description: 'Important',
        priority: 3,
      );
      expect(pt, isA<Task>());
      expect(pt.id, 'p1');
      expect(pt.priority, 3);
    });

    test('Task subtypes can be used in List<Task>', () {
      final tasks = <Task>[
        Task(id: '1', title: 'Normal'),
        RecurringTask(
          id: '2',
          title: 'Recurring',
          recurrence: Duration(days: 1),
        ),
        PriorityTask(id: '3', title: 'Priority', priority: 1),
      ];
      expect(tasks.length, 3);
      expect(tasks[0], isA<Task>());
      expect(tasks[1], isA<RecurringTask>());
      expect(tasks[2], isA<PriorityTask>());
    });

    test('copyWith preserves field values', () {
      final t1 = Task(id: 'x', title: 'Original', isDone: false);
      final t2 = t1.copyWith(isDone: true);
      expect(t2.id, 'x');
      expect(t2.title, 'Original');
      expect(t2.isDone, isTrue);
    });
  });
}
