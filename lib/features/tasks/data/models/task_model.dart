import 'package:flutter/material.dart';

import '../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.createdAt,
    super.deadline,
    super.isDone,
    super.isPinned,
    super.color,
  });

  factory TaskModel.fromTask(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      createdAt: task.createdAt,
      deadline: task.deadline,
      isDone: task.isDone,
      isPinned: task.isPinned,
      color: task.color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'isDone': isDone,
      'isPinned': isPinned,
      'colorValue': color.value,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    bool toBool(dynamic v) {
      if (v is bool) return v;
      if (v is int) return v != 0;
      if (v is String) return v == 'true' || v == '1';
      return false;
    }

    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      deadline: json['deadline'] != null
          ? DateTime.tryParse(json['deadline'] as String)
          : null,
      isDone: toBool(json['isDone']),
      isPinned: toBool(json['isPinned']),
      color: Color(json['colorValue'] as int? ?? Colors.white.value),
    );
  }
}

