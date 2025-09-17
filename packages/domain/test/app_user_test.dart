import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppUser', () {
    test('equality is based on fields', () {
      const a = AppUser(id: '1', email: 'a@b.com', displayName: 'A');
      const b = AppUser(id: '1', email: 'a@b.com', displayName: 'A');
      expect(a, equals(b));
    });

    test('copyWith updates selected fields only', () {
      const a = AppUser(id: '1', email: 'a@b.com', displayName: 'A');
      final b = a.copyWith(email: 'c@d.com');
      expect(b.id, '1');
      expect(b.email, 'c@d.com');
      expect(b.displayName, 'A');
      expect(b, isNot(equals(a)));
    });
  });
}
