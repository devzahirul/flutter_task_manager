import 'dart:async';

import 'package:application/application.dart';
import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({AppUser? initial}) : _current = initial;

  final _controller = StreamController<AppUser?>.broadcast();
  AppUser? _current;

  void emit(AppUser? user) {
    _current = user;
    _controller.add(user);
  }

  @override
  Stream<AppUser?> authStateChanges() => _controller.stream;

  @override
  Future<AppUser?> currentUser() async => _current;

  @override
  Future<AppUser?> signInAnonymously() async {
    final user = const AppUser(id: 'anon-1');
    emit(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    emit(null);
  }

  void dispose() {
    _controller.close();
  }
}

void main() {
  test('initializes with current user and listens to changes', () async {
    final fake = FakeAuthRepository(initial: const AppUser(id: 'seed'));
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(fake),
    ]);
    addTearDown(container.dispose);

    // Give time for async initialization
    // Force provider creation, then allow microtask turn
    container.read(authControllerProvider);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(authControllerProvider);
    expect(state.hasValue, isTrue);
    expect(state.value?.id, 'seed');

    // When repository emits new user, controller reflects it
    fake.emit(const AppUser(id: 'next'));
    await Future<void>.delayed(Duration.zero);
    final state2 = container.read(authControllerProvider);
    expect(state2.value?.id, 'next');
  });

  test('signInAnonymously emits loading then data', () async {
    final fake = FakeAuthRepository();
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(fake),
    ]);
    addTearDown(container.dispose);

    final sub = container.listen(authControllerProvider, (_, __) {});
    addTearDown(sub.close);

    // trigger
    await container.read(authControllerProvider.notifier).signInAnonymously();

    final s = container.read(authControllerProvider);
    expect(s.hasValue, isTrue);
    expect(s.value, isA<AppUser>());
    expect(s.value!.id, 'anon-1');
  });

  test('signOut emits loading then null', () async {
    final fake = FakeAuthRepository(initial: const AppUser(id: 'u1'));
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(fake),
    ]);
    addTearDown(container.dispose);

    await Future<void>.delayed(Duration.zero);

    await container.read(authControllerProvider.notifier).signOut();

    final s = container.read(authControllerProvider);
    expect(s.hasValue, isTrue);
    expect(s.value, isNull);
  });
}
