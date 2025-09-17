import 'dart:async';

import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tasksRepositoryProvider = Provider<TasksRepository>((ref) {
  throw UnimplementedError('Provide a TasksRepository via override');
});

final tasksControllerProvider =
    StateNotifierProvider<TasksController, AsyncValue<List<Task>>>((ref) {
  return TasksController(ref).._initialize();
});

class TasksController extends StateNotifier<AsyncValue<List<Task>>> {
  TasksController(this.ref) : super(const AsyncValue.data(<Task>[]));

  final Ref ref;
  StreamSubscription<List<Task>>? _sub;

  TasksRepository get _repo => ref.read(tasksRepositoryProvider);

  void _initialize() {
    // seed current list
    _repo.fetchTasks().then((value) => state = AsyncValue.data(value));
    _sub = _repo.watchTasks().listen((tasks) {
      state = AsyncValue.data(tasks);
    });
  }

  Future<void> addTask(String title) async {
    state = const AsyncValue.loading();
    await _repo.addTask(title);
    state = AsyncValue.data(await _repo.fetchTasks());
  }

  Future<void> toggleDone(Task task) async {
    state = const AsyncValue.loading();
    await _repo.updateTask(task.copyWith(isDone: !task.isDone));
    state = AsyncValue.data(await _repo.fetchTasks());
  }

  Future<void> deleteTask(String id) async {
    state = const AsyncValue.loading();
    await _repo.deleteTask(id);
    state = AsyncValue.data(await _repo.fetchTasks());
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

