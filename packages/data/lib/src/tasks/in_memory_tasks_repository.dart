import 'dart:async';

import 'package:domain/domain.dart';

class InMemoryTasksRepository implements TasksRepository {
  final _controller = StreamController<List<Task>>.broadcast();
  final List<Task> _tasks = [];
  int _idCounter = 0;

  InMemoryTasksRepository() {
    // seed initial empty list to watchers
    // Delay to ensure listeners can attach
    Future<void>.microtask(() => _controller.add(List.unmodifiable(_tasks)));
  }

  void _emit() {
    _controller.add(List.unmodifiable(_tasks));
  }

  @override
  Future<Task> addTask(String title) async {
    final task = Task(
      id: (++_idCounter).toString(),
      title: title,
      isDone: false,
      createdAt: DateTime.now(),
    );
    _tasks.add(task);
    _emit();
    return task;
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    _emit();
  }

  @override
  Future<List<Task>> fetchTasks() async => List.unmodifiable(_tasks);

  @override
  Stream<List<Task>> watchTasks() => _controller.stream;

  @override
  Future<void> updateTask(Task task) async {
    final idx = _tasks.indexWhere((t) => t.id == task.id);
    if (idx != -1) {
      _tasks[idx] = task;
      _emit();
    }
  }

  void dispose() {
    _controller.close();
  }
}

