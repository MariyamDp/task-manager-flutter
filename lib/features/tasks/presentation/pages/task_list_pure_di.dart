import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task.dart';
import '../../domain/services/task_validator.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/mark_done_usecase.dart';
import '../../domain/usecases/save_task_usecase.dart';
import '../../domain/usecases/toggle_pin_usecase.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../data/datasources/in_memory_data_source.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

/// A pure-constructor-injection variant of the task list page.
/// Uses an in-memory datasource and manual wiring instead of `get_it`.
class TaskListPureDIPage extends StatelessWidget {
  const TaskListPureDIPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Manual wiring for demonstration
    final dataSource = InMemoryDataSource();
    final repository = TaskRepositoryImpl(dataSource);
    final getTasks = GetTasksUseCase(repository);
    final saveTask = SaveTaskUseCase(repository);
    final deleteTask = DeleteTaskUseCase(repository);
    final togglePin = TogglePinUseCase(repository);
    final markDone = MarkDoneUseCase(repository);
    final validator = TaskValidator();

    final bloc = TaskBloc(
      getTasks,
      saveTask,
      deleteTask,
      togglePin,
      markDone,
      validator,
    );

    return BlocProvider.value(
      value: bloc..add(LoadTasks()),
      child: _PureWrapper(),
    );
  }
}

class _PureWrapper extends StatelessWidget {
  const _PureWrapper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager (Pure DI)')),
      body: const _PureListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(
            context,
          ).push<Task>(MaterialPageRoute(builder: (_) => const SizedBox()));
          if (result != null && context.mounted) {
            context.read<TaskBloc>().add(AddOrUpdateTask(result));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PureListView extends StatelessWidget {
  const _PureListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, dynamic>(
      builder: (context, state) {
        if (state is TaskLoading || state is TaskInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TaskError) {
          return Center(child: Text(state.message));
        }
        final tasks = state is TaskLoaded ? state.tasks : <Task>[];
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              title: Text(task.title),
              subtitle: Text(task.description),
              leading: IconButton(
                icon: Icon(
                  task.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                ),
                onPressed: () =>
                    context.read<TaskBloc>().add(TogglePinTask(task.id)),
              ),
              trailing: IconButton(
                icon: Icon(
                  task.isDone ? Icons.check_box : Icons.check_box_outline_blank,
                ),
                onPressed: () => context.read<TaskBloc>().add(
                  MarkTaskDone(task.id, !task.isDone),
                ),
              ),
              onTap: () {},
            );
          },
        );
      },
    );
  }
}
