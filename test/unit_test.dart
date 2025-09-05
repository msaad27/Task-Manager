import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/model/model.dart';

void main() {
  group('Task model tests', () {
    test('copyWith updates fields correctly', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Desc',
        status: TaskStatus.pending,
        deadline: DateTime(2025, 1, 1),
      );

      final updatedTask = task.copyWith(
        title: 'Updated Task',
        status: TaskStatus.completed,
        deadline: DateTime(2025, 12, 31),
      );

      expect(updatedTask.id, equals('1'));
      expect(updatedTask.title, equals('Updated Task'));
      expect(updatedTask.description, equals('Desc'));
      expect(updatedTask.status, equals(TaskStatus.completed));
      expect(updatedTask.deadline, equals(DateTime(2025, 12, 31)));
    });
  });
}
