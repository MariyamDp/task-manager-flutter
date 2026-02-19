import 'package:flutter/material.dart';

import '../../domain/entities/task.dart';

class TaskDetailPage extends StatefulWidget {
  final Task? initialTask;

  const TaskDetailPage({super.key, this.initialTask});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  DateTime? _deadline;
  Color _color = Colors.white;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialTask?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.initialTask?.description ?? '',
    );
    _deadline = widget.initialTask?.deadline;
    _color = widget.initialTask?.color ?? Colors.white;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: _deadline ?? now,
    );
    if (picked != null) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  void _selectColor(Color color) {
    setState(() {
      _color = color;
    });
  }

  void _save() {
    final now = DateTime.now();
    final updated = (widget.initialTask ??
            Task(
              id: now.microsecondsSinceEpoch.toString(),
              title: _titleController.text,
              description: _descriptionController.text,
              createdAt: now,
            ))
        .copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      deadline: _deadline,
      color: _color,
    );

    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialTask == null ? 'New Task' : 'Edit Task',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  _deadline == null
                      ? 'No deadline'
                      : 'Deadline: ${_deadline!.toLocal().toString().split(' ').first}',
                ),
                const Spacer(),
                TextButton(
                  onPressed: _pickDeadline,
                  child: const Text('Set deadline'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Color'),
            const SizedBox(height: 8),
            Row(
              children: [
                _ColorDot(
                  color: Colors.white,
                  selected: _color == Colors.white,
                  onTap: _selectColor,
                ),
                _ColorDot(
                  color: Colors.blue.shade50,
                  selected: _color == Colors.blue.shade50,
                  onTap: _selectColor,
                ),
                _ColorDot(
                  color: Colors.pink.shade50,
                  selected: _color == Colors.pink.shade50,
                  onTap: _selectColor,
                ),
                _ColorDot(
                  color: Colors.green.shade50,
                  selected: _color == Colors.green.shade50,
                  onTap: _selectColor,
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final bool selected;
  final ValueChanged<Color> onTap;

  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(color),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Theme.of(context).colorScheme.primary : Colors.grey,
          ),
        ),
      ),
    );
  }
}

