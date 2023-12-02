import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/widgets/bottom_navigation_widget.dart';

void main() {
  group('BottomNavigationWidget Tests', () {
    int selectedIndex = 0;

    void onItemSelected(int index) {
      selectedIndex = index;
    }

    testWidgets('BottomNavigationWidget displays and functions correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavigationWidget(
              onItemSelected: onItemSelected,
            ),
          ),
        ),
      );

      expect(find.byType(BottomNavigationBar), findsOneWidget);

      final bottomNavigationBar =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNavigationBar.items.length, equals(4));

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.attach_money), findsOneWidget);
      expect(find.byIcon(Icons.money_off), findsOneWidget);
      expect(find.byIcon(Icons.receipt), findsOneWidget);

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Expense'), findsOneWidget);
      expect(find.text('Reports'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.attach_money));
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(1));

      await tester.pumpAndSettle();

      expect(selectedIndex, equals(1));
    });
  });
}
