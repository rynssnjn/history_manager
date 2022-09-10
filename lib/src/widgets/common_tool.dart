import 'package:flutter/material.dart';

const _deactivated = Color(0xFFBDBDBD);

/// A Customizable [Widget] that is built with an icon and a title below.
class CommonTool extends StatelessWidget {
  const CommonTool({
    required this.onTap,
    this.isActive = false,
    this.isTitleShown = true,
    this.toolWidget,
    this.iconSize = 25,
    this.activeColor = Colors.black,
    this.inactiveColor = _deactivated,
    this.title,
    this.icon,
    Key? key,
  }) : super(key: key);

  /// The callback on tap of this widget.
  final VoidCallback onTap;

  /// Acts as an indicator to disable the undo button. The default value = [false].
  final bool? isActive;

  /// Acts as an indicator to show the [title] below the icon. The default value = [true].
  final bool? isTitleShown;

  /// The customized widget for the icon, this will replace the default icon that is current a widget [Icon] that
  /// shows an [Icons.abc]
  final Widget? toolWidget;

  /// The size of the icon. This defaults to [25] if null.
  final double? iconSize;

  /// The color of the button icon and the title icon when activated. This defaults to [Colors.black] if null.
  final Color? activeColor;

  /// The color of the button icon and the title icon when deactivated. This defaults to [Color(0xFFBDBDBD)]
  /// or [_deactivated] if null.
  final Color? inactiveColor;

  /// The title below the button. This defaults to an empty string if null.
  final String? title;

  /// The icon of the button if there will be no [toolWidget] passed. This defaults to [Icons.abc] and has a color of
  /// [activeColor] when [isActive] == [true] and [inactiveColor] when [isActive] == [false], the size of the icon will
  /// be the [iconSize]
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        if (isActive == true) {
          onTap();
        }
      },
      child: Column(
        children: [
          if (toolWidget != null)
            toolWidget!
          else
            Icon(
              icon ?? Icons.abc,
              color: isActive == true ? activeColor : inactiveColor,
              size: iconSize,
            ),
          if (isTitleShown == true)
            Text(
              title ?? '',
              style: textTheme.caption?.copyWith(color: isActive == true ? activeColor : inactiveColor),
            ),
        ],
      ),
    );
  }
}
