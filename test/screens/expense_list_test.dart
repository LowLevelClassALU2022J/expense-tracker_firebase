import 'package:expense_tracker/screens/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/firestore_service.dart';

class MockFirestoreService extends Mock implements FirestoreService {
  @override
  Stream<List<Expense>> getExpenses() {
    return Stream.value([
      Expense(
          id: '1',
          amount: 100.0,
          categoryId: 'cat1',
          categoryName: 'Groceries',
          description: 'Grocery shopping',
          date: DateTime.now()),
      Expense(
          id: '2',
          amount: 50.0,
          categoryId: 'cat2',
          categoryName: 'Transport',
          description: 'Bus fare',
          date: DateTime.now()),
    ]);
  }
}

void main() {
  group('ExpenseListScreen Tests', () {
    late MockFirestoreService mockFirestoreService;

    setUp(() {
      mockFirestoreService = MockFirestoreService();
    });

    testWidgets('ExpenseListScreen displays and interacts correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ExpenseListScreen(firestoreService: mockFirestoreService),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Expense List'), findsOneWidget);

      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('Transport'), findsOneWidget);

      expect(find.byIcon(Icons.edit), findsWidgets);
      expect(find.byIcon(Icons.delete), findsWidgets);
    });
  });
}
