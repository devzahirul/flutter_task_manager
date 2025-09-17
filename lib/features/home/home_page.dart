import 'package:application/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);
    final tasks = ref.watch(tasksControllerProvider);
    final tasksCtrl = ref.read(tasksControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: Center(
        child: state.when(
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
          data: (user) {
            if (user == null) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Signed out'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: controller.signInAnonymously,
                    child: const Text('Sign in anonymously'),
                  ),
                ],
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Signed in: ${user.id}'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: controller.signOut,
                  child: const Text('Sign out'),
                ),
                const SizedBox(height: 24),
                tasks.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('Tasks error: $e'),
                  data: (items) {
                    if (items.isEmpty) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('No tasks'),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            key: const Key('add_task_button'),
                            onPressed: () => tasksCtrl.addTask('Task ${DateTime.now().millisecondsSinceEpoch}'),
                            child: const Text('Add task'),
                          ),
                        ],
                      );
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 300,
                          width: 350,
                          child: ListView(
                            children: [
                              for (final t in items)
                                CheckboxListTile(
                                  value: t.isDone,
                                  title: Text(t.title),
                                  onChanged: (_) => tasksCtrl.toggleDone(t),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          key: const Key('add_task_button'),
                          onPressed: () => tasksCtrl.addTask('Task ${items.length + 1}'),
                          child: const Text('Add task'),
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
