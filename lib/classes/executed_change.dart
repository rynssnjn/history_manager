import 'package:flutter/material.dart';

typedef OnUndoChange<T> = Function(T oldValue);

abstract class ExecutedChange<T> {
  VoidCallback get onExecute;
  OnUndoChange<T> get onUndo;
  T get oldValue;

  void execute() => onExecute();

  void undo() => onUndo(oldValue);
}
