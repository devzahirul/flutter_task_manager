import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Task', () {
    test('equatable by id, title, isDone, createdAt', () {
      final a = Task(id: '1', title: 'A', isDone: false, createdAt: DateTime(2024));
      final b = Task(id: '1', title: 'A', isDone: false, createdAt: DateTime(2024));
      expect(a, equals(b));
    });

    test('copyWith updates fields', () {
      final a = Task(id: '1', title: 'A', isDone: false, createdAt: DateTime(2024));
      final b = a.copyWith(title: 'B', isDone: true);
      expect(b.id, '1');
      expect(b.title, 'B');
      expect(b.isDone, true);
      expect(b.createdAt, a.createdAt);
    });
  });
}
