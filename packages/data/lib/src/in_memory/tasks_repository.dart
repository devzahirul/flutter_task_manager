import 'dart:async';

import 'package:domain/domain.dart';
import '../models/task_dto.dart';

class InMemoryTasksRepository implements TasksRepository {
  late final StreamController<List<TaskDto>> _controller;
  final List<TaskDto> _tasks = [];
  int _idCounter = 0;

  InMemoryTasksRepository() {
    _controller = StreamController<List<TaskDto>>.broadcast(
      onListen: () => _controller.add(List.unmodifiable(_tasks)),
    );
  }

  void _emit() => _controller.add(List.unmodifiable(_tasks));

  @override
  Future<Task> addTask(String title) async {
    final dto = TaskDto(
      id: (++_idCounter).toString(),
      title: title,
      isDone: false,
      createdAt: DateTime.now(),
    );
    _tasks.add(dto);
    _emit();
    return _toDomain(dto);
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    _emit();
  }

  @override
  Future<List<Task>> fetchTasks() async =>
      _tasks.map(_toDomain).toList(growable: false);

  @override
  Stream<List<Task>> watchTasks() => _controller.stream
      .map((dtos) => dtos.map(_toDomain).toList(growable: false));

  @override
  Future<void> updateTask(Task task) async {
    final idx = _tasks.indexWhere((t) => t.id == task.id);
    if (idx != -1) {
      _tasks[idx] = _fromDomain(task);
      _emit();
    }
  }

  void dispose() {
    _controller.close();
  }

  Task _toDomain(TaskDto dto) => Task(
        id: dto.id,
        title: dto.title,
        isDone: dto.isDone,
        createdAt: dto.createdAt,
      );

  TaskDto _fromDomain(Task task) => TaskDto(
        id: task.id,
        title: task.title,
        isDone: task.isDone,
        createdAt: task.createdAt,
      );
}

