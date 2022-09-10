import 'package:flutter/material.dart';

typedef OnUndoChange<T> = Function(T oldValue);

/// An abstract class that should be extend to a custom class that will be added to the [HistoryController].
abstract class ExecutedChange<T> {
  /// The callback to be done when it is added to the [executedChanges] of the [HistoryController].
  VoidCallback get onExecute;

  /// The callback when the [HistoryController] has undone the change.
  OnUndoChange<T> get onUndo;

  /// The previous value before the change was executed. was called.
  T? get oldValue;

  void execute() => onExecute();

  void undo() => onUndo(oldValue as T);
}
