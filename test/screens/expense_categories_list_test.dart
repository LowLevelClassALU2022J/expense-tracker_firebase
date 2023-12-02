import 'package:expense_tracker/screens/expense_categories_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:expense_tracker/models/expense_category.dart';
import 'package:expense_tracker/services/firestore_service.dart';

class MockFirestoreService extends Mock implements FirestoreService {
  @override
  Stream<List<ExpenseCategory>> getExpenseCategories() {
    return Stream.value([
      ExpenseCategory(id: '1', name: 'Groceries'),
      ExpenseCategory(id: '2', name: 'Transport'),
    ]);
  }
}

void main() {
  group('EditExpenseCategoryScreen Tests', () {
    late MockFirestoreService mockFirestoreService;

    setUp(() {
      mockFirestoreService = MockFirestoreService();
    });

    testWidgets('EditExpenseCategoryScreen displays and interacts correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home:
              EditExpenseCategoryScreen(firestoreService: mockFirestoreService),
        ),
      );

      await tester.pumpAndSettle();

      // Check for AppBar title
      expect(find.widgetWithText(AppBar, 'Edit Expense Categories'),
          findsOneWidget);

      // Check for the presence of category items
      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('Transport'), findsOneWidget);

      // Check for edit and delete buttons
      expect(find.byIcon(Icons.edit), findsWidgets);
      expect(find.byIcon(Icons.delete), findsWidgets);
    });
  });
}
