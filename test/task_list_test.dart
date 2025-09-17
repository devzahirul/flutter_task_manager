import 'package:application/application.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_task_manager/features/home/home_page.dart';

void main() {
  testWidgets('shows empty state, can add and toggle a task', (tester) async {
    final tasksRepo = InMemoryTasksRepository();
    final authRepo = InMemoryAuthRepository();
    await authRepo.signInAnonymously();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tasksRepositoryProvider.overrideWithValue(tasksRepo),
          authRepositoryProvider.overrideWithValue(authRepo),
        ],
        child: const MaterialApp(home: HomePage()),
      ),
    );

    // allow auth controller to read current user
    await tester.pump();

    expect(find.text('No tasks'), findsOneWidget);

    await tester.tap(find.byKey(const Key('add_task_button')));
    await tester.pump();

    expect(find.byType(CheckboxListTile), findsOneWidget);

    // toggle checkbox
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();

    // Still present, now checked (no visual assert, just no crash)
    expect(find.byType(CheckboxListTile), findsOneWidget);
  });
}
