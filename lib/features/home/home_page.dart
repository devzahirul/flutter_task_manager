import 'package:application/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _textCtrl = TextEditingController();

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          SizedBox(
                            width: 320,
                            child: TextField(
                              key: const Key('task_input'),
                              controller: _textCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Task title',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (_) async {
                                final title = _textCtrl.text.trim();
                                await tasksCtrl.addTask(
                                  title.isEmpty ? 'Task 1' : title,
                                );
                                _textCtrl.clear();
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            key: const Key('add_task_button'),
                            onPressed: () async {
                              final title = _textCtrl.text.trim();
                              await tasksCtrl.addTask(title.isEmpty ? 'Task 1' : title);
                              _textCtrl.clear();
                            },
                            child: const Text('Add task'),
                          ),
                        ],
                      );
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 320,
                          child: TextField(
                            key: const Key('task_input'),
                            controller: _textCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Task title',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) async {
                              final title = _textCtrl.text.trim();
                              await tasksCtrl.addTask(
                                title.isEmpty ? 'Task ${items.length + 1}' : title,
                              );
                              _textCtrl.clear();
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
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
                                  secondary: IconButton(
                                    key: Key('delete_task_${t.id}'),
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => tasksCtrl.deleteTask(t.id),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          key: const Key('add_task_button'),
                          onPressed: () async {
                            final title = _textCtrl.text.trim();
                            await tasksCtrl.addTask(
                              title.isEmpty ? 'Task ${items.length + 1}' : title,
                            );
                            _textCtrl.clear();
                          },
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
