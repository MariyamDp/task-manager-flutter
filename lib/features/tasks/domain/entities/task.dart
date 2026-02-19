import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? deadline;
  final bool isDone;
  final bool isPinned;
  final Color color;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    DateTime? createdAt,
    this.deadline,
    this.isDone = false,
    this.isPinned = false,
    this.color = Colors.white,
  }) : createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? deadline,
    bool? isDone,
    bool? isPinned,
    Color? color,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      deadline: deadline ?? this.deadline,
      isDone: isDone ?? this.isDone,
      isPinned: isPinned ?? this.isPinned,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    createdAt,
    deadline,
    isDone,
    isPinned,
    color,
  ];
}

class RecurringTask extends Task {
  final Duration recurrence;

  RecurringTask({
    required String id,
    required String title,
    String description = '',
    DateTime? createdAt,
    DateTime? deadline,
    bool isDone = false,
    bool isPinned = false,
    Color color = Colors.white,
    required this.recurrence,
  }) : super(
         id: id,
         title: title,
         description: description,
         createdAt: createdAt,
         deadline: deadline,
         isDone: isDone,
         isPinned: isPinned,
         color: color,
       );
}

class PriorityTask extends Task {
  final int priority;

  PriorityTask({
    required String id,
    required String title,
    String description = '',
    DateTime? createdAt,
    DateTime? deadline,
    bool isDone = false,
    bool isPinned = false,
    Color color = Colors.white,
    this.priority = 1,
  }) : assert(priority >= 1 && priority <= 3),
       super(
         id: id,
         title: title,
         description: description,
         createdAt: createdAt,
         deadline: deadline,
         isDone: isDone,
         isPinned: isPinned,
         color: color,
       );
}
