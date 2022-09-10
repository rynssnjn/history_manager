import 'package:flutter/material.dart';
import 'package:history_manager/history_manager.dart';
import 'package:history_manager/src/widgets/common_tool.dart';

const _deactivated = Color(0xFFBDBDBD);

const _redoText = 'REDO';

const _undoText = 'UNDO';

/// A customizable [Widget] that displays an undo and redo tools. Commonly used thru applications to provide redoing
/// and undoing of changes or common mistakes in performing an action or change.
class CommonHistoryTools extends StatelessWidget {
  const CommonHistoryTools({
    required this.onUndo,
    required this.onRedo,
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
    Key? key,
  }) : super(key: key);

  /// A void callback to perform on tap of undo button. This is a [required] property.
  final VoidCallback onUndo;

  /// A void callback to perform on tap of undo button. This is a [required] property.
  final VoidCallback onRedo;

  /// Acts as an indicator to disable the undo button. The default value = [false].
  final bool? canUndo;

  /// Acts as an indicator to disable the redo button. The default value = [false].
  final bool? canRedo;

  /// Acts as an indicator to show the [undoTitle] and [redoTitle] below their respective buttons.
  /// The default value = [true].
  final bool? isTitleShown;

  /// The title below the undo button. This defaults to [UNDO] if null.
  final String? undoTitle;

  /// The title below the redo button. This defaults to [REDO] if null.
  final String? redoTitle;

  /// The customized widget for undo tool, this will replace the default undo tool that is designed as [CommonTool].
  final Widget? undoTool;

  /// The customized widget for redo tool, this will replace the default redo tool that is designed as [CommonTool].
  final Widget? redoTool;

  /// The color of the buttons icon and the title icon when activated. This defaults to [Colors.black] if null.
  final Color? activatedColor;

  /// The color of the buttons icon and the title icon when deactivated. This defaults to [Color(0xFFBDBDBD)]
  /// or [_deactivated] if null.
  final Color? deactivatedColor;

  /// The size of the icons for both undo and redo tools. This defaults to [25] if null.
  final double? iconSize;

  /// The [MainAxisAlignment] or the row. This defaults to [MainAxisAlignment.spaceBetween] if null.
  final MainAxisAlignment? mainAxisAlignment;

  /// The [CrossAxisAlignment] or the row. This defaults to [CrossAxisAlignment.center] if null.
  final CrossAxisAlignment? crossAxisAlignment;

  /// The [MainAxisSize] or the row. This defaults to [MainAxisSize.min] if null.
  final MainAxisSize? mainAxisSize;

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
          const SizedBox(width: 15),
          Container(
            height: iconSize,
            width: 2,
            color: _deactivated,
          ),
          const SizedBox(width: 15),
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
