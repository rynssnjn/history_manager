import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:history_manager/history_manager.dart';

void main() {
  group('Action buttons has title', () {
    Future<void> _createStepToolsWidget(
      WidgetTester tester, {
      String undoTitle,
      String redoTitle,
      bool isTitleShown = true,
    }) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CommonHistoryTools(
            onUndo: () {},
            onRedo: () {},
            undoTitle: undoTitle,
            redoTitle: redoTitle,
            isTitleShown: isTitleShown,
          ),
        ),
      ));
    }

    testWidgets('Checks the given title for the actions', (tester) async {
      final undoTitle = 'undo';
      final redoTitle = 'redo';
      await _createStepToolsWidget(
        tester,
        undoTitle: undoTitle,
        redoTitle: redoTitle,
      );

      final undoTitleFinder = find.text(undoTitle);
      final redoTitleFinder = find.text(redoTitle);

      expect(undoTitleFinder, findsOneWidget);
      expect(redoTitleFinder, findsOneWidget);
    });

    testWidgets('Checks the default title for the actions when there are no given titles', (tester) async {
      await _createStepToolsWidget(tester);

      final undoTitleFinder = find.text('UNDO');
      final redoTitleFinder = find.text('REDO');

      expect(undoTitleFinder, findsOneWidget);
      expect(redoTitleFinder, findsOneWidget);
    });

    testWidgets('Hide titles of the actions', (tester) async {
      await _createStepToolsWidget(tester, isTitleShown: false);

      final textWidgetFinder = find.byType(Text);

      expect(textWidgetFinder, findsNothing);
    });

    testWidgets('Show titles of the actions', (tester) async {
      await _createStepToolsWidget(tester);

      final textWidgetFinder = find.byType(Text);

      expect(textWidgetFinder, findsNWidgets(2));
    });
  });

  group('Icons/Widgets for redo and undo action buttons', () {
    Future<void> _createStepToolsWidget(
      WidgetTester tester, {
      Widget undoTool,
      Widget redoTool,
      bool isTitleShown = true,
    }) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CommonHistoryTools(
            onUndo: () {},
            onRedo: () {},
            undoTool: undoTool,
            redoTool: redoTool,
            isTitleShown: isTitleShown,
          ),
        ),
      ));
    }

    testWidgets(
        'Checks the default icons used for the widget when no widgets are provided for `undoTool` and `redoTool`',
        (tester) async {
      await _createStepToolsWidget(tester);

      final undoIconFinder = find.byIcon(Icons.undo_rounded);
      final redoIconFinder = find.byIcon(Icons.redo_rounded);
      final iconFinder = find.byType(Icon);

      expect(undoIconFinder, findsOneWidget);
      expect(redoIconFinder, findsOneWidget);
      expect(iconFinder, findsNWidgets(2));
    });

    testWidgets('Custom widget is passed as an action icon for undo and redo', (tester) async {
      await _createStepToolsWidget(
        tester,
        undoTool: IconButton(
          onPressed: () {},
          icon: Icon(Icons.abc),
        ),
        redoTool: Text('Redo'),
        isTitleShown: false,
      );

      final undoIconFinder = find.byIcon(Icons.abc);
      final iconFinder = find.byType(Icon);
      final textWidgetFinder = find.byType(Text);

      expect(undoIconFinder, findsOneWidget);
      expect(iconFinder, findsOneWidget);
      expect(textWidgetFinder, findsOneWidget);
    });
  });

  group('Tapping of icons', () {
    Future<void> _createTestToolWidget(
      WidgetTester tester, {
      VoidCallback onChange,
      bool canUndo = false,
      bool canRedo = false,
    }) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CommonHistoryTools(
            onUndo: onChange,
            onRedo: onChange,
            canUndo: canUndo,
            canRedo: canRedo,
          ),
        ),
      ));
    }

    group('undo tapping', () {
      testWidgets('On tap of tool when active', (tester) async {
        var testString = 'TEST TOOL';
        final tapTestedString = 'TAP TESTED';
        await _createTestToolWidget(
          tester,
          onChange: () => testString = tapTestedString,
          canUndo: true,
        );

        final widgetTool = find.byType(InkWell);
        expect(widgetTool, findsNWidgets(2));

        // Taps the inkwell
        await tester.tap(widgetTool.first, pointer: 1);
        await tester.pump(const Duration(seconds: 1));
        expect(testString, tapTestedString);
      });
      testWidgets('On tap of tool when inactive', (tester) async {
        var testString = 'TEST TOOL';
        final tapTestedString = 'TAP TESTED';
        await _createTestToolWidget(
          tester,
          onChange: () => testString = tapTestedString,
        );

        final widgetTool = find.byType(InkWell);
        expect(widgetTool, findsNWidgets(2));

        // Taps the inkwell
        await tester.tap(widgetTool.first, pointer: 1);
        await tester.pump(const Duration(seconds: 1));
        expect(testString == tapTestedString, false);
      });
    });

    group('redo tapping', () {
      testWidgets('On tap of tool when active', (tester) async {
        var testString = 'TEST TOOL';
        final tapTestedString = 'TAP TESTED';
        await _createTestToolWidget(
          tester,
          onChange: () => testString = tapTestedString,
          canRedo: true,
        );

        final widgetTool = find.byType(InkWell);
        expect(widgetTool, findsNWidgets(2));

        // Taps the inkwell
        await tester.tap(widgetTool.last, pointer: 1);
        await tester.pump(const Duration(seconds: 1));
        expect(testString, tapTestedString);
      });
      testWidgets('On tap of tool when inactive', (tester) async {
        var testString = 'TEST TOOL';
        final tapTestedString = 'TAP TESTED';
        await _createTestToolWidget(
          tester,
          onChange: () => testString = tapTestedString,
        );

        final widgetTool = find.byType(InkWell);
        expect(widgetTool, findsNWidgets(2));

        // Taps the inkwell
        await tester.tap(widgetTool.last, pointer: 1);
        await tester.pump(const Duration(seconds: 1));
        expect(testString == tapTestedString, false);
      });
    });
  });
}
