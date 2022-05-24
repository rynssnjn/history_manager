import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:history_manager/widgets/common_tool.dart';

void main() {
  group('Title visibility', () {
    Future<void> _createCommonTool(
      WidgetTester tester, {
      bool isTitleShown = true,
      String title,
    }) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CommonTool(
            onTap: () {},
            isTitleShown: isTitleShown,
            title: title,
          ),
        ),
      ));
    }

    testWidgets('Shows title with default title', (tester) async {
      await _createCommonTool(tester);

      final textWidgetFinder = find.byType(Text);
      final titleFinder = find.text('Action Title');

      expect(textWidgetFinder, findsOneWidget);
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('Shows title with provided title', (tester) async {
      await _createCommonTool(tester, title: 'Test');

      final textWidgetFinder = find.byType(Text);
      final titleFinder = find.text('Test');

      expect(textWidgetFinder, findsOneWidget);
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('Hides title with provided title with title provided', (tester) async {
      await _createCommonTool(tester, isTitleShown: false);

      final textWidgetFinder = find.byType(Text);
      final titleFinder = find.text('Action Title');

      expect(textWidgetFinder, findsNothing);
      expect(titleFinder, findsNothing);
    });

    testWidgets('Hides title with provided title without title provided', (tester) async {
      await _createCommonTool(tester, isTitleShown: false, title: 'Test');

      final textWidgetFinder = find.byType(Text);
      final titleFinder = find.text('Test');

      expect(textWidgetFinder, findsNothing);
      expect(titleFinder, findsNothing);
    });
  });

  group('Icon/Widget of the tool', () {
    Future<void> _createCommonTool(
      WidgetTester tester, {
      Widget toolWidget,
      IconData icon,
    }) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CommonTool(
            onTap: () {},
            toolWidget: toolWidget,
            icon: icon,
          ),
        ),
      ));
    }

    testWidgets('With nothing provided', (tester) async {
      await _createCommonTool(tester);

      final iconFinder = find.byIcon(Icons.abc);

      expect(iconFinder, findsOneWidget);
    });

    testWidgets('With widget provided', (tester) async {
      await _createCommonTool(
        tester,
        toolWidget: Text('TEST TOOL'),
      );

      final iconFinder = find.byIcon(Icons.abc);
      final textFinder = find.text('TEST TOOL');
      final textWidgetFinder = find.byType(Text);

      expect(iconFinder, findsNothing);
      expect(textFinder, findsOneWidget);

      // including title
      expect(textWidgetFinder, findsNWidgets(2));
    });

    testWidgets('With icon data provided', (tester) async {
      await _createCommonTool(tester, icon: Icons.dangerous);

      final iconFinder = find.byIcon(Icons.abc);
      final providedIconFinder = find.byIcon(Icons.dangerous);

      expect(iconFinder, findsNothing);
      expect(providedIconFinder, findsOneWidget);
    });
  });

  group('Tapping of tool', () {
    Future<void> _createCommonTool(
      WidgetTester tester, {
      VoidCallback onTap,
      bool isActive = false,
    }) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CommonTool(
            onTap: onTap,
            isActive: isActive,
          ),
        ),
      ));
    }

    testWidgets('On tap of tool when active', (tester) async {
      var testString = 'TEST TOOL';
      final tapTestedString = 'TAP TESTED';

      await _createCommonTool(
        tester,
        onTap: () => testString = tapTestedString,
        isActive: true,
      );

      final widgetTool = find.byType(InkWell);
      expect(widgetTool, findsOneWidget);

      // Taps the inkwell
      await tester.tap(widgetTool, pointer: 1);
      await tester.pump(const Duration(seconds: 1));
      expect(testString, tapTestedString);
    });

    testWidgets('On tap of tool when inactive', (tester) async {
      var testString = 'TEST TOOL';
      final tapTestedString = 'TAP TESTED';

      await _createCommonTool(tester, onTap: () => testString = tapTestedString);

      final widgetTool = find.byType(InkWell);
      expect(widgetTool, findsOneWidget);

      // Taps the inkwell
      await tester.tap(widgetTool, pointer: 1);
      await tester.pump(const Duration(seconds: 1));
      expect(testString == tapTestedString, false);
    });
  });
}
