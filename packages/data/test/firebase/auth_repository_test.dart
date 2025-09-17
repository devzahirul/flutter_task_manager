import 'dart:async';

import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockFirebaseAuth extends Mock implements fb.FirebaseAuth {}

class _MockUser extends Mock implements fb.User {}

class _MockUserCredential extends Mock implements fb.UserCredential {}

void main() {

  group('FirebaseAuthRepository', () {
    late _MockFirebaseAuth mockAuth;
    late FirebaseAuthRepository repo;

    setUp(() {
      mockAuth = _MockFirebaseAuth();
      repo = FirebaseAuthRepository(auth: mockAuth);
    });

    test('authStateChanges maps to AppUser', () async {
      final mockUser = _MockUser();
      when(() => mockUser.uid).thenReturn('uid-123');
      when(() => mockUser.email).thenReturn('u@e.com');
      when(() => mockUser.displayName).thenReturn('User');

      when(() => mockAuth.authStateChanges()).thenAnswer((_) => Stream.value(mockUser));

      final first = await repo.authStateChanges().first;
      expect(first, isA<AppUser>());
      expect(first!.id, 'uid-123');
      expect(first.email, 'u@e.com');
      expect(first.displayName, 'User');
    });

    test('currentUser maps to AppUser', () async {
      final mockUser = _MockUser();
      when(() => mockUser.uid).thenReturn('uid-1');
      when(() => mockUser.email).thenReturn(null);
      when(() => mockUser.displayName).thenReturn(null);

      when(() => mockAuth.currentUser).thenReturn(mockUser);

      final current = await repo.currentUser();
      expect(current, isA<AppUser>());
      expect(current!.id, 'uid-1');
      expect(current.email, isNull);
    });

    test('signInAnonymously maps to AppUser', () async {
      final mockUser = _MockUser();
      when(() => mockUser.uid).thenReturn('anon-uid');
      when(() => mockUser.email).thenReturn(null);
      when(() => mockUser.displayName).thenReturn(null);

      final cred = _MockUserCredential();
      when(() => cred.user).thenReturn(mockUser);

      when(() => mockAuth.signInAnonymously()).thenAnswer((_) async => cred);

      final user = await repo.signInAnonymously();
      expect(user, isA<AppUser>());
      expect(user!.id, 'anon-uid');
    });

    test('signOut delegates to FirebaseAuth', () async {
      when(() => mockAuth.signOut()).thenAnswer((_) async {});

      await repo.signOut();

      verify(() => mockAuth.signOut()).called(1);
    });
  });
}

