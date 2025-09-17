import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/domain.dart';
import '../models/task_dto.dart';

class FirestoreTasksRepository implements TasksRepository {
  FirestoreTasksRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('tasks');

  TaskDto _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    final created = data['createdAtMillis'];
    DateTime createdAt;
    if (created is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(created);
    } else if (created is Timestamp) {
      createdAt = created.toDate();
    } else {
      createdAt = DateTime.fromMillisecondsSinceEpoch(0);
    }
    return TaskDto(
      id: doc.id,
      title: (data['title'] as String?) ?? '',
      isDone: (data['isDone'] as bool?) ?? false,
      createdAt: createdAt,
    );
  }

  Map<String, Object?> _toMap(TaskDto task) => <String, Object?>{
        'title': task.title,
        'isDone': task.isDone,
        'createdAtMillis': task.createdAt.millisecondsSinceEpoch,
      };

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

  @override
  Stream<List<Task>> watchTasks() {
    final query = _col.orderBy('createdAtMillis', descending: false);
    return query
        .snapshots()
        .map((snap) => snap.docs.map((d) => _fromDoc(d)).toList())
        .map((dtos) => dtos.map(_toDomain).toList());
  }

  @override
  Future<List<Task>> fetchTasks() async {
    final snap = await _col.orderBy('createdAtMillis', descending: false).get();
    final dtos = snap.docs.map((d) => _fromDoc(d)).toList();
    return dtos.map(_toDomain).toList();
  }

  @override
  Future<Task> addTask(String title) async {
    final now = DateTime.now();
    final doc = _col.doc();
    await doc.set(<String, Object?>{
      'title': title,
      'isDone': false,
      'createdAtMillis': now.millisecondsSinceEpoch,
    });
    return Task(id: doc.id, title: title, isDone: false, createdAt: now);
  }

  @override
  Future<void> updateTask(Task task) async {
    final doc = _col.doc(task.id);
    await doc.update(_toMap(_fromDomain(task)));
  }

  @override
  Future<void> deleteTask(String id) async {
    await _col.doc(id).delete();
  }
}
