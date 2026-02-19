// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:db_task_manager/core/di/register_module.dart' as _i876;
import 'package:db_task_manager/features/tasks/data/datasources/firebase_data_source.dart'
    as _i52;
import 'package:db_task_manager/features/tasks/data/datasources/i_task_data_source.dart'
    as _i215;
import 'package:db_task_manager/features/tasks/data/datasources/in_memory_data_source.dart'
    as _i751;
import 'package:db_task_manager/features/tasks/data/datasources/local_storage_data_source.dart'
    as _i665;
import 'package:db_task_manager/features/tasks/data/datasources/sqlite_data_source.dart'
    as _i1066;
import 'package:db_task_manager/features/tasks/data/datasources/task_data_source.dart'
    as _i386;
import 'package:db_task_manager/features/tasks/data/repositories/task_repository_impl.dart'
    as _i251;
import 'package:db_task_manager/features/tasks/domain/repositories/task_repository.dart'
    as _i132;
import 'package:db_task_manager/features/tasks/domain/services/notification_service.dart'
    as _i215;
import 'package:db_task_manager/features/tasks/domain/services/task_report_generator.dart'
    as _i659;
import 'package:db_task_manager/features/tasks/domain/services/task_validator.dart'
    as _i159;
import 'package:db_task_manager/features/tasks/domain/usecases/delete_task_usecase.dart'
    as _i341;
import 'package:db_task_manager/features/tasks/domain/usecases/get_tasks_usecase.dart'
    as _i906;
import 'package:db_task_manager/features/tasks/domain/usecases/mark_done_usecase.dart'
    as _i372;
import 'package:db_task_manager/features/tasks/domain/usecases/save_task_usecase.dart'
    as _i340;
import 'package:db_task_manager/features/tasks/domain/usecases/toggle_pin_usecase.dart'
    as _i839;
import 'package:db_task_manager/features/tasks/presentation/bloc/task_bloc.dart'
    as _i919;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:sqflite/sqflite.dart' as _i779;

const String _dev = 'dev';
const String _cloud = 'cloud';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.singleton<_i215.NotificationService>(() => _i215.NotificationService());
    gh.singleton<_i659.TaskReportGenerator>(() => _i659.TaskReportGenerator());
    gh.singleton<_i159.TaskValidator>(() => _i159.TaskValidator());
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i386.ITaskDataSource>(
      () => _i665.LocalStorageDataSource(gh<_i460.SharedPreferences>()),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i215.ITaskDataSource>(
      () => _i751.InMemoryDataSource(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i386.ITaskDataSource>(
      () => _i52.FirebaseDataSource(gh<_i361.Dio>()),
      registerFor: {_cloud},
    );
    await gh.lazySingletonAsync<_i779.Database>(
      () => registerModule.database,
      registerFor: {_prod},
      preResolve: true,
    );
    gh.lazySingleton<_i386.ITaskDataSource>(
      () => _i1066.SQLiteDataSource(gh<_i779.Database>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i132.ITaskRepository>(
      () => _i251.TaskRepositoryImpl(gh<_i215.ITaskDataSource>()),
    );
    gh.factory<_i341.DeleteTaskUseCase>(
      () => _i341.DeleteTaskUseCase(gh<_i132.ITaskRepository>()),
    );
    gh.factory<_i906.GetTasksUseCase>(
      () => _i906.GetTasksUseCase(gh<_i132.ITaskRepository>()),
    );
    gh.factory<_i372.MarkDoneUseCase>(
      () => _i372.MarkDoneUseCase(gh<_i132.ITaskRepository>()),
    );
    gh.factory<_i340.SaveTaskUseCase>(
      () => _i340.SaveTaskUseCase(gh<_i132.ITaskRepository>()),
    );
    gh.factory<_i839.TogglePinUseCase>(
      () => _i839.TogglePinUseCase(gh<_i132.ITaskRepository>()),
    );
    gh.factory<_i919.TaskBloc>(
      () => _i919.TaskBloc(
        gh<_i906.GetTasksUseCase>(),
        gh<_i340.SaveTaskUseCase>(),
        gh<_i341.DeleteTaskUseCase>(),
        gh<_i839.TogglePinUseCase>(),
        gh<_i372.MarkDoneUseCase>(),
        gh<_i159.TaskValidator>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i876.RegisterModule {}
