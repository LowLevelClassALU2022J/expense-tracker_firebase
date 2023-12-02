import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/widgets/top_navigation_widget.dart';

void main() {
  group('TopNavigationWidget Tests', () {
    testWidgets('TopNavigationWidget displays correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          appBar: TopNavigationWidget(),
          drawer: Drawer(),
        ),
      ));

      expect(find.widgetWithText(AppBar, 'Expense Tracker'), findsOneWidget);

      expect(find.byIcon(Icons.menu), findsOneWidget);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.byType(Drawer), findsOneWidget);
    });
  });
}
