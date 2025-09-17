import 'task.dart';

abstract class TasksRepository {
  Stream<List<Task>> watchTasks();
  Future<List<Task>> fetchTasks();
  Future<Task> addTask(String title);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
}

