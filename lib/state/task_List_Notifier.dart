import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:task_manager/model/model.dart';

part 'task_List_Notifier.g.dart';

@riverpod
class TaskList extends _$TaskList {
  @override
  List<Task> build() => [];

  void addTask(String title, String description, {DateTime? deadline}) {
    final task = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      status: TaskStatus.pending,
      deadline: deadline,
    );
    state = [...state, task];
  }

  void deleteTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }

  void undoDelete(Task task) {
    state = [...state, task];
  }

  void updateTitle(String id, String newTitle) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(title: newTitle) else task,
    ];
  }

  void updateDescription(String id, String newDescription) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(description: newDescription) else task,
    ];
  }

  void startTask(String id) {
    _setStatus(id, TaskStatus.started);
  }

  void completeTask(String id) {
    _setStatus(id, TaskStatus.completed);
  }

  void setDeadline(String id, DateTime deadline) {
    state = [
      for (final task in state)
        if (task.id == id)
          task.copyWith(deadline: deadline)
        else
          task,
    ];
  }

  void _setStatus(String id, TaskStatus status) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(status: status) else task,
    ];
  }
}
