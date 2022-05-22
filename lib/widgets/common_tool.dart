import 'package:flutter/material.dart';

class CommonTool extends StatelessWidget {
  const CommonTool({
    @required this.onTap,
    this.isActive = false,
    this.isTitleShown = true,
    this.toolWidget,
    this.iconSize = 25,
    this.activeColor,
    this.inactiveColor,
    this.title,
    this.icon,
    Key key,
  }) : super(key: key);

  final VoidCallback onTap;
  final bool isActive;
  final bool isTitleShown;
  final Widget toolWidget;
  final double iconSize;
  final Color activeColor;
  final Color inactiveColor;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        if (isActive) {
          onTap();
        }
      },
      child: Column(
        children: [
          if (toolWidget != null)
            toolWidget
          else
            Icon(
              icon ?? Icons.abc,
              color: isActive ? activeColor : inactiveColor,
              size: iconSize,
            ),
          if (isTitleShown)
            Text(
              title ?? 'Action Title',
              style: textTheme.caption.copyWith(color: isActive ? activeColor : inactiveColor),
            ),
        ],
      ),
    );
  }
}
