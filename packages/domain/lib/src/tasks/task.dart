import 'package:equatable/equatable.dart';

class Task extends Equatable {
  const Task({required this.id, required this.title, required this.isDone, required this.createdAt});

  final String id;
  final String title;
  final bool isDone;
  final DateTime createdAt;

  Task copyWith({String? id, String? title, bool? isDone, DateTime? createdAt}) => Task(
        id: id ?? this.id,
        title: title ?? this.title,
        isDone: isDone ?? this.isDone,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  List<Object?> get props => [id, title, isDone, createdAt];
}

