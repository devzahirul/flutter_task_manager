// ignore_for_file: subtype_of_sealed_class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockFirestore extends Mock implements FirebaseFirestore {}

class _MockCollection extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class _MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class _MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class _MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class _MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

void main() {
  group('FirestoreTasksRepository', () {
    late _MockFirestore db;
    late _MockCollection col;
    late FirestoreTasksRepository repo;

    setUp(() {
      db = _MockFirestore();
      col = _MockCollection();
      when(() => db.collection('tasks')).thenReturn(col);
      repo = FirestoreTasksRepository(firestore: db);
    });

    test('fetchTasks maps snapshot to tasks', () async {
      final q = _MockQuery();
      when(() => col.orderBy('createdAtMillis', descending: false))
          .thenReturn(q);

      final snap = _MockQuerySnapshot();
      when(() => q.get()).thenAnswer((_) async => snap);

      final d1 = _MockQueryDocumentSnapshot();
      when(() => d1.id).thenReturn('a');
      when(d1.data).thenReturn({
        'title': 'One',
        'isDone': false,
        'createdAtMillis': 1000,
      });

      final d2 = _MockQueryDocumentSnapshot();
      when(() => d2.id).thenReturn('b');
      when(d2.data).thenReturn({
        'title': 'Two',
        'isDone': true,
        'createdAtMillis': 2000,
      });

      when(() => snap.docs).thenReturn([d1, d2]);

      final tasks = await repo.fetchTasks();
      expect(tasks.length, 2);
      expect(tasks.first.id, 'a');
      expect(tasks.first.title, 'One');
      expect(tasks.last.isDone, true);
    });

    test('addTask writes doc and returns task', () async {
      final doc = _MockDocumentReference();
      when(() => col.doc()).thenReturn(doc);
      when(() => doc.id).thenReturn('new-id');
      when(() => doc.set(any())).thenAnswer((_) async {});

      final t = await repo.addTask('Title');

      expect(t.id, 'new-id');
      expect(t.title, 'Title');

      verify(() => doc.set(any(that: isA<Map<String, Object?>>().having(
            (m) => m['title'], 'title', 'Title',
          ).having(
            (m) => m['isDone'], 'isDone', false,
          )))).called(1);
    });

    test('updateTask calls update with mapped data', () async {
      final doc = _MockDocumentReference();
      when(() => col.doc('1')).thenReturn(doc);
      when(() => doc.update(any())).thenAnswer((_) async {});

      final task = Task(
        id: '1',
        title: 'T',
        isDone: true,
        createdAt: DateTime.fromMillisecondsSinceEpoch(1000),
      );
      await repo.updateTask(task);

      verify(() => doc.update(
            any(that: isA<Map<String, Object?>>().having(
              (m) => m['isDone'], 'isDone', true,
            )),
          )).called(1);
    });

    test('deleteTask calls delete', () async {
      final doc = _MockDocumentReference();
      when(() => col.doc('1')).thenReturn(doc);
      when(() => doc.delete()).thenAnswer((_) async {});

      await repo.deleteTask('1');
      verify(() => doc.delete()).called(1);
    });

    test('watchTasks maps stream results', () async {
      final q = _MockQuery();
      when(() => col.orderBy('createdAtMillis', descending: false))
          .thenReturn(q);

      final snap = _MockQuerySnapshot();
      final d = _MockQueryDocumentSnapshot();
      when(() => d.id).thenReturn('x');
      when(d.data).thenReturn({
        'title': 'X',
        'isDone': false,
        'createdAtMillis': 123,
      });
      when(() => snap.docs).thenReturn([d]);

      when(() => q.snapshots()).thenAnswer((_) => Stream.value(snap));

      final first = await repo.watchTasks().first;
      expect(first.single.title, 'X');
    });
  });
}

