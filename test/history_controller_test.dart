import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:history_manager/history_manager.dart';

import 'classes/name_step.dart';

void main() {
  var name = '';

  late HistoryController undoController;

  void _initController() => undoController = HistoryController(initialCapacity: 10)
    ..add(NameStep(
      onExecute: () => name = 'Initial Name',
      onUndo: (oldValue) => name = oldValue,
      oldValue: name,
    ));

  test('add(), Add executed change on undo', () {
    _initController();
    final change = NameStep(
      onExecute: () => name = 'Test Name 1',
      onUndo: (oldValue) => name = oldValue,
      oldValue: name,
    );

    undoController.add(change);

    expect(undoController.executedChanges.length, 2);
    expect(undoController.canUndo, true);
  });

  group('redoing and undoing action', () {
    const expectedUndoName = 'Initial Name';
    const expectedRedoName = 'Test Name for undo 2';
    test('redo(), Redo the previous undone change', () {
      _initController();
      final change1 = NameStep(
        onExecute: () => name = 'Test Name for undo 1',
        onUndo: (oldValue) => name = oldValue,
        oldValue: name,
      );

      final change2 = NameStep(
        onExecute: () => name = 'Test Name for undo 2',
        onUndo: (oldValue) => name = oldValue,
        oldValue: name,
      );

      // Adds new step.
      undoController.add(change1);
      undoController.add(change2);

      // Undone the newly added
      undoController.undo();
      expect(undoController.canUndo, true);
      expect(undoController.canRedo, true);
      expect(undoController.executedChanges.length, 2);
      expect(undoController.redos.length, 1);
      expect(name, expectedUndoName);

      // Redo the undone action
      undoController.redo();
      expect(undoController.canRedo, false);
      expect(undoController.redos.length, 0);
      expect(undoController.executedChanges.length, 3);
      expect(name, expectedRedoName);
    });

    test('undo(), Undo the previous change', () {
      _initController();
      final change = NameStep(
        onExecute: () => name = 'Test Name for undo',
        onUndo: (oldValue) => name = oldValue,
        oldValue: name,
      );

      // Adds new step.
      undoController.add(change);

      // Undone the newly added
      undoController.undo();
      expect(undoController.executedChanges.length, 1);
      expect(undoController.redos.length, 1);
      expect(name, expectedUndoName);
    });
  });

  group('setting values for redos and executedChanges', () {
    final defaultStep = NameStep(
      onExecute: () {},
      onUndo: (_) {},
    );
    final testStep = Queue<NameStep>();

    test('setting values for redos', () {
      _initController();
      undoController.redos = testStep..add(defaultStep);

      expect(undoController.canRedo, true);
      expect(undoController.redos.length, 1);
    });

    test('setting values for executedChanges', () {
      _initController();
      undoController.executedChanges = testStep;

      expect(undoController.canUndo, true);
      expect(undoController.executedChanges.length, 1);
    });
  });

  test('clear(), Clearing redos and executedChanges', () {
    _initController();
    undoController.clear();

    expect(undoController.executedChanges.length, 0);
    expect(undoController.redos.length, 0);
  });
}
