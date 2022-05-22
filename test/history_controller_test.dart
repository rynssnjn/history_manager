import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:history_manager/history_manager.dart';

import 'classes/name_step.dart';

void main() {
  var name = '';

  HistoryController undoController;

  void _initController() => undoController = HistoryController()
    ..add(NameStep(
      onExecute: () => name = 'Initial Name',
      onUndo: (oldValue) => name = oldValue,
      oldValue: name,
    ));

  group('Adding changes on stack', () {
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

    test('addGroup(), Adds multiple entry on undoable steps', () {
      _initController();
      final changes = [
        NameStep(
          onExecute: () => name = 'Added Name 1',
          onUndo: (oldValue) => name = oldValue,
          oldValue: name,
        ),
        NameStep(
          onExecute: () => name = 'Added Name 2',
          onUndo: (oldValue) => name = oldValue,
          oldValue: name,
        ),
        NameStep(
          onExecute: () => name = 'Added Name 3',
          onUndo: (oldValue) => name = oldValue,
          oldValue: name,
        ),
      ];

      undoController.addGroup<String>(changes);

      expect(undoController.executedChanges.length, 2);
      expect(undoController.canUndo, true);
    });
  });

  group('redoing and undoing action', () {
    final expectedUndoName = 'Initial Name';
    final expectedRedoName = 'Test Name for undo 2';
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
    final testStep = Queue.of([
      [
        NameStep(
          onExecute: () {},
          onUndo: (_) {},
        ),
      ]
    ]);

    test('setting values for redos', () {
      _initController();
      undoController.redos = testStep;

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
    undoController.dispose();

    expect(undoController.executedChanges.length, 0);
    expect(undoController.redos.length, 0);
  });
}
