import 'package:expense_tracker/screens/reports_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:expense_tracker/services/firestore_service.dart';

class MockFirestoreService extends Mock implements FirestoreService {
  @override
  Future<List<double>> getIncomesList() {
    // Provide mock data for incomes
    return Future.value([100.0, 200.0, 300.0]);
  }

  @override
  Future<List<double>> getExpensesList() {
    // Provide mock data for expenses
    return Future.value([50.0, 150.0, 250.0]);
  }
}

void main() {
  group('ReportScreen Tests', () {
    late MockFirestoreService mockFirestoreService;

    setUp(() {
      mockFirestoreService = MockFirestoreService();
    });

    testWidgets('ReportScreen displays and interacts correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ReportScreen(firestoreService: mockFirestoreService),
        ),
      );

      await tester.pumpAndSettle();

      // Check for AppBar title and TabBar items
      expect(find.widgetWithText(AppBar, 'Report'), findsOneWidget);
      expect(find.text('Daily'), findsOneWidget);
      expect(find.text('Weekly'), findsOneWidget);
      expect(find.text('Monthly'), findsOneWidget);

      // Check for segment controls
      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Expense'), findsOneWidget);

      // Check for the chart
      expect(find.byType(LineChart), findsOneWidget);

      // Check for the top income/expense indicator
      expect(find.text('Top Income'), findsOneWidget);

      // Additional checks for values and other UI elements can be added as needed
    });
  });
}
