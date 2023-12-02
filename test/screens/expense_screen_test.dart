import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:expense_tracker/models/income_category.dart';
import 'package:expense_tracker/services/firestore_service.dart';
import 'package:expense_tracker/screens/income_screen.dart';

class MockFirestoreService extends Mock implements FirestoreService {
  @override
  Stream<List<IncomeCategory>> getIncomeCategories() {
    return Stream.value([
      IncomeCategory(id: '1', name: 'Salary'),
      IncomeCategory(id: '2', name: 'Freelance'),
    ]);
  }
}

void main() {
  group('IncomeScreen Tests', () {
    late MockFirestoreService mockFirestoreService;

    setUp(() {
      mockFirestoreService = MockFirestoreService();
    });

    testWidgets('IncomeScreen displays and interacts correctly',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: IncomeScreen(firestoreService: mockFirestoreService),
          ),
        );
      });

      await tester.pumpAndSettle();

      await tester.pump();

      expect(find.byType(IncomeScreen), findsOneWidget);

      expect(find.widgetWithText(AppBar, 'Add Income'), findsOneWidget);

      expect(
          find.widgetWithText(TextFormField, 'Income Amount'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Description (Optional)'),
          findsOneWidget);

      expect(find.byType(DropdownButton<IncomeCategory>), findsOneWidget);

      expect(find.widgetWithText(ElevatedButton, 'Add Income'), findsOneWidget);

      expect(find.widgetWithText(ElevatedButton, 'Add New Income Category'),
          findsOneWidget);

      expect(find.widgetWithText(ElevatedButton, 'View All Income'),
          findsOneWidget);

      expect(find.widgetWithText(ElevatedButton, 'View All Income Categories'),
          findsOneWidget);
    });
  });
}

