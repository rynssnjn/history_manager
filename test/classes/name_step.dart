import 'package:flutter/material.dart';
import 'package:history_manager/history_manager.dart';

class NameStep extends ExecutedChange<String> {
  NameStep({
    @required this.onExecute,
    @required this.onUndo,
    this.oldValue,
  });

  @override
  final String oldValue;

  @override
  final VoidCallback onExecute;

  @override
  final OnUndoChange<String> onUndo;
}
