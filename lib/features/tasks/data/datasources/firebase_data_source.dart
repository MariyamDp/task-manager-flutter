import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/task.dart';
import '../models/task_model.dart';
import 'task_data_source.dart';

/// Example remote data source to demonstrate Open/Closed and LSP.
/// You can wire this up to a real Firebase backend if desired.
@Environment('cloud')
@LazySingleton(as: ITaskDataSource)
class FirebaseDataSource implements ITaskDataSource {
  final Dio _dio;

  FirebaseDataSource(this._dio);

  static const _baseUrl = 'https://example-firebase-tasks.com/tasks';

  @override
  Future<void> delete(String id) async {
    await _dio.delete('$_baseUrl/$id.json');
  }

  @override
  Future<List<Task>> readAll() async {
    final response = await _dio.get('$_baseUrl.json');
    if (response.data == null) return [];
    final data = Map<String, dynamic>.from(response.data as Map);
    return data.entries
        .map(
          (e) => TaskModel.fromJson(
            {
              'id': e.key,
              ...Map<String, dynamic>.from(e.value as Map),
            },
          ),
        )
        .toList();
  }

  @override
  Future<void> save(Task item) async {
    final model = TaskModel.fromTask(item);
    await _dio.put(
      '$_baseUrl/${item.id}.json',
      data: model.toJson(),
    );
  }

  @override
  Future<void> markDone(String id, bool isDone) async {
    await _dio.patch(
      '$_baseUrl/$id.json',
      data: {'isDone': isDone},
    );
  }

  @override
  Future<void> togglePin(String id) async {
    await _dio.patch(
      '$_baseUrl/$id.json',
      data: {'togglePin': true},
    );
  }
}

