class TaskDto {
  const TaskDto({required this.id, required this.title, required this.isDone, required this.createdAt});

  final String id;
  final String title;
  final bool isDone;
  final DateTime createdAt;
}

