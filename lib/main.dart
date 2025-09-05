import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/state/task_List_Notifier.dart';
import 'package:task_manager/model/model.dart';
import 'package:task_manager/theme/theme.dart';

void main() {
  runApp(const ProviderScope(child: TodoApp()));
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: const TaskListScreen(),
    );
  }
}

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider).reversed.toList();
    final notifier = ref.read(taskListProvider.notifier);

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Task Manager')),
      body: ListView.separated(
        itemCount: tasks.length,
        separatorBuilder: (_, __) => const Divider(height: 10),
        itemBuilder: (_, index) {
          final task = tasks[index];
          return _TaskCard(task: task, notifier: notifier);
        },
      ),
      floatingActionButton: const _AddTaskButton(),
    );
  }
}

class _AddTaskButton extends StatefulWidget {
  const _AddTaskButton();

  @override
  State<_AddTaskButton> createState() => _AddTaskButtonState();
}

class _AddTaskButtonState extends State<_AddTaskButton> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _selectedDeadline;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final notifier = ref.read(taskListProvider.notifier);

      return FloatingActionButton(
        onPressed: () {
          _titleController.clear();
          _descController.clear();
          _selectedDeadline = null;

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration:  InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Title',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _descController,
                      decoration:  InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selectedDeadline != null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(_selectedDeadline!)
                                : 'Select a date',
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => _selectedDeadline = picked);
                            }
                          },
                          child: const Text('Pick Date'),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final title = _titleController.text.trim();
                      final desc = _descController.text.trim();

                      if (title.isNotEmpty) {
                        notifier.addTask(title, desc, deadline: _selectedDeadline);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      );
    });
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final TaskList notifier;

  const _TaskCard({
    required this.task,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final color = switch (task.status) {
      TaskStatus.completed => Colors.green[800],
      TaskStatus.started => Colors.blueGrey[800],
      TaskStatus.pending => Colors.red[800],
    };

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Delete this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
      onDismissed: (_) {
        notifier.deleteTask(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted "${task.title}"'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () => notifier.undoDelete(task),
            ),
          ),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        color: color,
        child: ListTile(
          title: GestureDetector(
            onTap: () => _showEditDialog(context),
            child: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                decoration: task.status == TaskStatus.completed
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(task.description),
              ],
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 6),
                  Text(DateFormat('dd/MM/yyyy').format(task.deadline ?? DateTime.now())),
                  if (task.status != TaskStatus.completed)
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: task.deadline ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          notifier.setDeadline(task.id, picked);
                        }
                      },
                    ),
                ],
              ),
            ],
          ),
          trailing: switch (task.status) {
            TaskStatus.pending => ElevatedButton(
                onPressed: () => notifier.startTask(task.id),
                child: const Text('Start'),
              ),
            TaskStatus.started => ElevatedButton(
                onPressed: () => notifier.completeTask(task.id),
                child: const Text('Complete'),
              ),
            TaskStatus.completed => null,
          },
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final titleController = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description);
    DateTime? selectedDeadline = task.deadline;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Task'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedDeadline != null
                              ? DateFormat('dd/MM/yyyy').format(selectedDeadline!)
                              : 'Update deadline',
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDeadline ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDeadline = picked;
                            });
                          }
                        },
                        child: const Text('Pick Date'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final newTitle = titleController.text.trim();
                  final newDesc = descController.text.trim();

                  if (newTitle.isNotEmpty) {
                    notifier.updateTitle(task.id, newTitle);
                    notifier.updateDescription(task.id, newDesc);
                    if (selectedDeadline != null) {
                      notifier.setDeadline(task.id, selectedDeadline!);
                    }
                  }

                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }
}
