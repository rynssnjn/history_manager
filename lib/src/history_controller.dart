import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:history_manager/history_manager.dart';

/// - Holds undo and redo functionalities for the session of this controller.
/// - Extends to [ChangeNotifier] to notify changes for the mutable properties to take changes in the UI State.
class HistoryController extends ChangeNotifier {
  HistoryController({
    required this.initialCapacity,
  }) {
    _executedChanges = ListQueue(initialCapacity);
    _redos = ListQueue(initialCapacity);
  }

  /// Prepares the queue for at least that many elements. Applies to both
  /// `_executedChanges` and `_redos` [ListQueue]s
  final int initialCapacity;

  // * Mutable Properties
  /// Stack of executed changes during a session.
  late Queue<ExecutedChange> _executedChanges;

  /// Stack of executed undos and that can be redo upon undoing a specific action.
  late Queue<ExecutedChange> _redos;

  // * Getters
  /// Checker if stack can still redo actions
  bool get canRedo => _redos.isNotEmpty;

  /// Checker if stack can still undo actions
  bool get canUndo => _executedChanges.isNotEmpty;

  /// Returns the value _executedChanges.
  Queue<ExecutedChange> get executedChanges => _executedChanges;

  /// Returns the value _redos.
  Queue<ExecutedChange> get redos => _redos;

  // * Setters
  /// Sets value for `_redos`
  set redos(Queue<ExecutedChange> redo) {
    _redos = redo;
    notifyListeners();
  }

  /// Sets value for `_executedChanges`
  set executedChanges(Queue<ExecutedChange> executedChanges) {
    _executedChanges = executedChanges;
    notifyListeners();
  }

  // * Public methods

  /// - Redo the last undone action.
  /// - Checks if `_redos` stack is not empty to be able to know if there is an action that cane be redone.
  /// - Calls all `execute()` method of each change to apply the changes for the session.
  /// - Adds the redoable change to `_executedChanges`.
  void redo() {
    if (canRedo) {
      final change = _redos.removeLast();
      change.execute();
      _executedChanges.addLast(change);
      notifyListeners();
    }
  }

  /// - Undo the last change from the session.
  /// - Checks if `_executedChanges` is not empty to be able to undone the last change.
  /// - Adds the change at the last index of `_redos` stack.
  void undo() {
    if (canUndo) {
      final change = _executedChanges.removeLast();
      change.undo();
      _redos.addLast(change);
      notifyListeners();
    }
  }

  /// - Adds an [ExecutedChange] to the last position of the `_executedChanges` stack.
  /// - Clears `_redos` stack when change is added to `_executedChanges`.
  ///
  /// # Parameter:
  ///   - change : The [ExecutedChange] done from the session of this stack. The [ExecutedChange] to be added at the
  ///              last position of `_executedChanges` stack.
  void add<T>(ExecutedChange<T> change) {
    change.execute();
    _executedChanges.addLast(change);
    _redos.clear();
    notifyListeners();
  }

  /// Clears both `_executedChanges` and `_redos` stacks.
  void clear() {
    _executedChanges.clear();
    _redos.clear();
    notifyListeners();
  }
}
