import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/income.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:expense_tracker/services/firestore_service.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/widgets/credit_card_widget.dart';

class MockFirestoreService extends Mock implements FirestoreService {
  @override
  Future<Income?> getLatestIncome() {
    // Mock latest income data
    return Future.value(Income(
      id: '1',
      amount: 1000,
      description: 'Salary',
      categoryName: 'Salary',
      categoryId: '1',
      date: DateTime.now(),
    ));
  }

  @override
  Future<Expense?> getLatestExpense() {
    // Mock latest expense data
    return Future.value(Expense(
      id: '1',
      amount: 100,
      description: 'Groceries',
      categoryName: 'Groceries',
      categoryId: '1',
      date: DateTime.now(),
    ));
  }
}

void main() {
  group('HomeScreen Tests', () {
    late MockFirestoreService mockFirestoreService;

    setUp(() {
      mockFirestoreService = MockFirestoreService();
    });

    testWidgets('HomeScreen displays and interacts correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(firestoreService: mockFirestoreService),
        ),
      );

      await tester.pumpAndSettle();

      // Check for CreditCardWidget
      expect(find.byType(CreditCardWidget), findsOneWidget);

      // Check for buttons
      expect(find.widgetWithText(ElevatedButton, 'View All Income'),
          findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'View All Income Categories'),
          findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'View All Expenses'),
          findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'View All Expense Categories'),
          findsOneWidget);

      // Check for "Recent Activity" title
      expect(find.text('Recent Activity'), findsOneWidget);
    });
  });
}
