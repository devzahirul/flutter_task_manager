import 'package:application/application.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_task_manager/features/home/home_page.dart';

void main() {
  group('HomePage', () {
    testWidgets('shows sign-in when signed out and can sign in', (tester) async {
      final repo = InMemoryAuthRepository();
      final tasksRepo = InMemoryTasksRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(repo),
            tasksRepositoryProvider.overrideWithValue(tasksRepo),
          ],
          child: const MaterialApp(home: HomePage()),
        ),
      );

      expect(find.text('Sign in anonymously'), findsOneWidget);
      expect(find.textContaining('Signed in:'), findsNothing);

      await tester.tap(find.text('Sign in anonymously'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));

      expect(find.text('Sign out'), findsOneWidget);
      expect(find.textContaining('Signed in:'), findsOneWidget);
    });

    testWidgets('shows sign out when signed in and can sign out', (tester) async {
      final repo = InMemoryAuthRepository();
      final tasksRepo = InMemoryTasksRepository();
      await repo.signInAnonymously();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(repo),
            tasksRepositoryProvider.overrideWithValue(tasksRepo),
          ],
          child: const MaterialApp(home: HomePage()),
        ),
      );

      // Let initial currentUser seed state
      await tester.pump();

      expect(find.text('Sign out'), findsOneWidget);
      expect(find.textContaining('Signed in:'), findsOneWidget);

      await tester.tap(find.text('Sign out'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));

      expect(find.text('Sign in anonymously'), findsOneWidget);
      expect(find.textContaining('Signed in:'), findsNothing);
    });
  });
}
