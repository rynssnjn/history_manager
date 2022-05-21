// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:undo_manager/classes/executed_change.dart';

/// - Holds undo and redo functionalities for the session of this controller.
/// - Extends to [ChangeNotifier] to notify changes for the mutable properties to take changes in the UI State.
class UndoController extends ChangeNotifier {
  UndoController();

  // * Mutable Properties
  /// Stack of executed changes during a session.
  Queue<List<ExecutedChange>> _executedChanges = ListQueue();

  /// Stack of executed undos and that can be redo upon undoing a specific action.
  Queue<List<ExecutedChange>> _redos = ListQueue();

  // * Getters
  /// Checker if stack can still redo actions
  bool get canRedo => _redos.isNotEmpty;

  /// Checker if stack can still undo actions
  bool get canUndo => _executedChanges.isNotEmpty;

  // * Setters
  /// Sets value for `_redos`
  set redos(Queue<List<ExecutedChange>> redo) {
    _redos = redo;
    notifyListeners();
  }

  /// Sets value for `_executedChanges`
  set executedChanges(Queue<List<ExecutedChange>> executedChanges) {
    _executedChanges = executedChanges;
    notifyListeners();
  }

  // * Public methods
  /// - Adds an [ExecutedChange] to the last position of the `_executedChanges` stack.
  /// - Clears `_redos` stack when change is added to `_executedChanges`.
  ///
  /// # Parameter:
  ///   - change : The [ExecutedChange] done from the session of this stack. The [ExecutedChange] to be added at the
  ///              last position of `_executedChanges` stack.
  void add<T>(ExecutedChange<T> change) {
    change.execute();
    _executedChanges.addLast([change]);
    _redos.clear();
    notifyListeners();
  }

  /// - Adds a list of an [ExecutedChange] to the last position of the `_executedChanges` stack.
  /// - Calls all `execute()` method of each change to apply the changes for the session.
  /// - Clears `_redos` stack when change is added to `_executedChanges`.
  ///
  /// # Parameter:
  ///   - changes : The list of [ExecutedChange]s done from the session of this stack. To be added at the
  ///              last position of `_executedChanges` stack.
  void addGroup<T>(List<ExecutedChange<T>> changes) {
    changes.forEach((change) => change.execute());
    _executedChanges.addLast(changes);
    _redos.clear();
    notifyListeners();
  }

  /// Clears both `_executedChanges` and `_redos` stacks.
  void clear() {
    _executedChanges.clear();
    _redos.clear();
    notifyListeners();
  }

  /// - Redo the last undone action.
  /// - Checks if `_redos` stack is not empty to be able to know if there is an action that cane be redone.
  /// - Calls all `execute()` method of each change to apply the changes for the session.
  /// - Adds the redoable change to `_executedChanges`.
  void redo() {
    if (canRedo) {
      final changes = _redos.removeFirst();
      changes.forEach((change) => change.execute());
      _executedChanges.addLast(changes);
    }
  }

  /// - Undo the last change from the session.
  /// - Checks if `_executedChanges` is not empty to be able to undone the last change.
  /// - Adds the change at the first index of `_redos` stack.
  void undo() {
    if (canUndo) {
      final changes = _executedChanges.removeLast();
      changes.forEach((change) => change.undo());
      _redos.addFirst(changes);
    }
  }

  // * Overridden methods from [ChangeNotifier]
  @override
  void dispose() {
    clear();
    super.dispose();
  }

  @override
  String toString() => 'Redos: $_redos, Executed Changes: $_executedChanges';
}
