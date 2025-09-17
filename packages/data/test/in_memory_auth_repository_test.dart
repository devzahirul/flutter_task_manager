import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InMemoryAuthRepository', () {
    late InMemoryAuthRepository repo;

    setUp(() {
      repo = InMemoryAuthRepository();
    });

    tearDown(() {
      repo.dispose();
    });

    test('currentUser is null initially', () async {
      expect(await repo.currentUser(), isNull);
    });

    test('signInAnonymously emits user and updates currentUser', () async {
      final events = <AppUser?>[];
      final sub = repo.authStateChanges().listen(events.add);

      final user = await repo.signInAnonymously();

      expect(user, isNotNull);
      expect(user!.id, 'anon-1');
      expect(await repo.currentUser(), user);

      // give stream a microtask turn
      await Future<void>.delayed(Duration.zero);
      expect(events, contains(user));

      await sub.cancel();
    });

    test('signOut emits null and clears currentUser', () async {
      final events = <AppUser?>[];
      final sub = repo.authStateChanges().listen(events.add);

      await repo.signInAnonymously();
      await Future<void>.delayed(Duration.zero);
      events.clear();

      await repo.signOut();
      expect(await repo.currentUser(), isNull);

      await Future<void>.delayed(Duration.zero);
      expect(events, [null]);

      await sub.cancel();
    });
  });
}
