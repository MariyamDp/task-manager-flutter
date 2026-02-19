import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import 'task_detail_page.dart';
import 'task_list_pure_di.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TaskBloc>()..add(LoadTasks()),
      child: const _TaskListView(),
    );
  }
}

class _TaskListView extends StatelessWidget {
  const _TaskListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Task Manager',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'pure') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TaskListPureDIPage()),
                );
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'pure', child: Text('Open Pure DI')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _HeaderHints(),
            Expanded(
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoading || state is TaskInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is TaskError) {
                    return Center(child: Text(state.message));
                  }
                  final tasks = state is TaskLoaded ? state.tasks : <Task>[];
                  return Column(
                    children: [
                      _MemeBanner(tasks: tasks),
                      const SizedBox(height: 8),
                      if (tasks.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'No tasks for today',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return _TaskTile(task: task);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<Task>(
            MaterialPageRoute(builder: (_) => const TaskDetailPage()),
          );
          if (result != null && context.mounted) {
            context.read<TaskBloc>().add(AddOrUpdateTask(result));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _HeaderHints extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xffe0e4ee))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tap a task to edit or press + to add',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              final result = await Navigator.of(context).push<Task>(
                MaterialPageRoute(builder: (_) => const TaskDetailPage()),
              );
              if (result != null && context.mounted) {
                context.read<TaskBloc>().add(AddOrUpdateTask(result));
              }
            },
            child: const Text('New Task'),
          ),
        ],
      ),
    );
  }
}

class _MemeBanner extends StatelessWidget {
  final List<Task> tasks;

  const _MemeBanner({required this.tasks});

  @override
  Widget build(BuildContext context) {
    final asset = _selectAsset();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: asset == null
          ? const SizedBox.shrink()
          : Container(
              key: ValueKey(asset),
              margin: const EdgeInsets.only(top: 8),
              height: 140,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  asset,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Error loading GIF: $asset');
                    debugPrint('Error: $error');
                    return Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.image_not_supported_outlined,
                            size: 48,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'GIF not found',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            asset,
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  String? _selectAsset() {
    final random = Random();

    const lessThanTwo = [
      'assets/memes/lessthan2/Happy Season 5 GIF by The Office.gif',
      'assets/memes/lessthan2/Happy Shaquille O Neal GIF by Papa Johns.gif',
      'assets/memes/lessthan2/Excited Happy New Year GIF.gif',
      'assets/memes/lessthan2/Happy Jennifer Aniston GIF.gif',
    ];

    const moreThanTwo = [
      'assets/memes/morethan2/Stressed Spongebob Squarepants GIF.gif',
      'assets/memes/morethan2/Excited Season 2 GIF by The Office.gif',
      'assets/memes/morethan2/The Boyz Stare GIF.gif',
      'assets/memes/morethan2/Nervous The Big Bang Theory GIF.gif',
    ];

    if (tasks.isEmpty || tasks.length < 2) {
      if (lessThanTwo.isEmpty) return null;
      return lessThanTwo[random.nextInt(lessThanTwo.length)];
    }
    if (moreThanTwo.isEmpty) return null;
    return moreThanTwo[random.nextInt(moreThanTwo.length)];
  }
}

class _TaskTile extends StatelessWidget {
  final Task task;

  const _TaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      background: _buildPinBackground(
        context,
        pinned: task.isPinned,
        alignLeft: true,
      ),
      secondaryBackground: _buildDeleteBackground(context),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          context.read<TaskBloc>().add(TogglePinTask(task.id));
          return false;
        } else {
          final confirmed =
              await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete task'),
                  content: const Text(
                    'Are you sure you want to delete this task?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ) ??
              false;
          if (confirmed) {
            context.read<TaskBloc>().add(DeleteTask(task.id));
          }
          return confirmed;
        }
      },
      child: GestureDetector(
        onTap: () async {
          final updated = await Navigator.of(context).push<Task>(
            MaterialPageRoute(
              builder: (_) => TaskDetailPage(initialTask: task),
            ),
          );
          if (updated != null && context.mounted) {
            context.read<TaskBloc>().add(AddOrUpdateTask(updated));
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: task.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (task.isPinned)
                          const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons.push_pin,
                              color: Colors.blue,
                              size: 16,
                            ),
                          ),
                        Flexible(
                          child: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Created: ${task.createdAt.toLocal().toString().split(' ').first}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (task.deadline != null)
                          Text(
                            'Due: ${task.deadline!.toLocal().toString().split(' ').first}',
                            style: TextStyle(
                              color: Colors.redAccent.shade200,
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _AnimatedStatusSquare(
                isDone: task.isDone,
                onTap: () {
                  context.read<TaskBloc>().add(
                    MarkTaskDone(task.id, !task.isDone),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinBackground(
    BuildContext context, {
    required bool pinned,
    required bool alignLeft,
  }) {
    return Container(
      alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: Colors.blue.shade50,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            pinned ? Icons.push_pin : Icons.push_pin_outlined,
            color: Colors.blue,
          ),
          const SizedBox(width: 8),
          Text(
            pinned ? 'Unpin' : 'Pin',
            style: const TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteBackground(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: Colors.red.shade100,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.delete_outline, color: Colors.red),
          SizedBox(width: 8),
          Text('Delete', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}

class _AnimatedStatusSquare extends StatelessWidget {
  final bool isDone;
  final VoidCallback onTap;

  const _AnimatedStatusSquare({required this.isDone, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: isDone
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green.shade400, Colors.green.shade600],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.grey.shade300, Colors.grey.shade400],
                ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: (isDone ? Colors.green : Colors.grey).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: isDone
              ? const Icon(
                  Icons.check_rounded,
                  key: ValueKey('check'),
                  color: Colors.white,
                  size: 28,
                  weight: 600,
                )
              : Container(
                  key: const ValueKey('empty'),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  margin: const EdgeInsets.all(10),
                ),
        ),
      ),
    );
  }
}
