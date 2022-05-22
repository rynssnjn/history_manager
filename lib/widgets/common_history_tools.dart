import 'package:flutter/material.dart';
import 'package:history_manager/history_manager.dart';

const _deactivated = Color(0xFFBDBDBD);

const _redoText = 'REDO';

const _undoText = 'UNDO';

class CommonHistoryTools extends StatelessWidget {
  const CommonHistoryTools({
    @required this.onUndo,
    @required this.onRedo,
    this.canUndo = false,
    this.canRedo = false,
    this.isTitleShown = true,
    this.undoTitle,
    this.redoTitle,
    this.undoTool,
    this.redoTool,
    this.activatedColor = Colors.black,
    this.deactivatedColor = _deactivated,
    this.iconSize = 25,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.mainAxisSize,
    Key key,
  }) : super(key: key);

  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final bool canUndo;
  final bool canRedo;
  final bool isTitleShown;
  final String undoTitle;
  final String redoTitle;
  final Widget undoTool;
  final Widget redoTool;
  final Color activatedColor;
  final Color deactivatedColor;
  final double iconSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
        mainAxisSize: mainAxisSize ?? MainAxisSize.min,
        children: [
          CommonTool(
            onTap: onUndo,
            isActive: canUndo,
            isTitleShown: isTitleShown,
            toolWidget: undoTool,
            iconSize: iconSize,
            activeColor: activatedColor,
            inactiveColor: deactivatedColor,
            title: undoTitle ?? _undoText,
            icon: Icons.undo_rounded,
          ),
          SizedBox(width: 15),
          Container(
            height: iconSize,
            width: 2,
            color: _deactivated,
          ),
          SizedBox(width: 15),
          CommonTool(
            onTap: onRedo,
            isActive: canRedo,
            isTitleShown: isTitleShown,
            toolWidget: redoTool,
            iconSize: iconSize,
            activeColor: activatedColor,
            inactiveColor: deactivatedColor,
            title: redoTitle ?? _redoText,
            icon: Icons.redo_rounded,
          ),
        ],
      ),
    );
  }
}
