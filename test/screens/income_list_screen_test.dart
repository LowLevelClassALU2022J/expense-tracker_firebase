import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:expense_tracker/models/income.dart';
import 'package:expense_tracker/services/firestore_service.dart';
import 'package:expense_tracker/screens/income_list_screen.dart';
import 'package:intl/intl.dart';

class MockFirestoreService extends Mock implements FirestoreService {
  @override
  Stream<List<Income>> getIncomes() {
    return Stream.value([
      Income(
          id: '1',
          amount: 150.0,
          categoryId: 'cat1',
          categoryName: 'Salary',
          description: 'Monthly salary',
          date: DateTime.now()),
      Income(
          id: '2',
          amount: 75.0,
          categoryId: 'cat2',
          categoryName: 'Freelance',
          description: 'Freelance project',
          date: DateTime.now()),
    ]);
  }
}

void main() {
  group('IncomeListScreen Tests', () {
    late MockFirestoreService mockFirestoreService;

    setUp(() {
      mockFirestoreService = MockFirestoreService();
    });

    testWidgets('IncomeListScreen displays and interacts correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: IncomeListScreen(firestoreService: mockFirestoreService),
        ),
      );

      await tester.pumpAndSettle();

      // Check for AppBar title
      expect(find.widgetWithText(AppBar, 'Income List'), findsOneWidget);

      // Check for the presence of income items
      expect(find.text('Salary'), findsOneWidget);
      expect(find.text('Freelance'), findsOneWidget);

      // Verify the display of amounts and dates
      expect(find.textContaining('\$150.0'), findsOneWidget);
      expect(find.textContaining('\$75.0'), findsOneWidget);
      expect(
          find.text(DateFormat.yMMMd().format(DateTime.now())), findsWidgets);

      // Check for edit and delete buttons
      expect(find.byIcon(Icons.edit), findsWidgets);
      expect(find.byIcon(Icons.delete), findsWidgets);

      // Additional tests can be added to simulate dialog interactions if needed
    });
  });
}
