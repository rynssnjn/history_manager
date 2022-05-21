import 'package:flutter/material.dart';

typedef OnUndoChange<T> = Function(T oldValue);
typedef OnExecuteChange = void Function();

abstract class ExecutedChange<T> {
  const ExecutedChange({
    @required this.onExecute,
    @required this.onUndo,
    this.oldValue,
  });

  final VoidCallback onExecute;
  final OnUndoChange<T> onUndo;
  final T oldValue;

  void execute() => onExecute();

  void undo() => onUndo(oldValue);
}
