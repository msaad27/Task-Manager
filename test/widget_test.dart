// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/main.dart';

void main() {
  testWidgets('App shows Task Manager title and Add button', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TodoApp()));

    expect(find.text('Task Manager'), findsOneWidget);

    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Add Task dialog opens on FAB tap', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TodoApp()));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Add Task'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Title'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Description'), findsOneWidget);
    expect(find.text('Pick Date'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
  });
}
