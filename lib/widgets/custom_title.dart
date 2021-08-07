import 'package:flutter/material.dart';

import '../constants.dart';

class CustomTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget icon;
  final Widget subtitle;
  final Widget trailing;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;

  CustomTile({
    required this.leading,
    required this.title,
    this.icon = const SizedBox(),
    required this.subtitle,
    this.trailing = const SizedBox(),
    this.margin = const EdgeInsets.all(0),
    required this.onTap,
    required this.onLongPress,
    this.mini = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: kSeparatorColor.withOpacity(0.2),
      overlayColor: MaterialStateColor.resolveWith(
          (states) => Colors.white.withOpacity(0.1)),
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: margin,
        child: Row(
          children: <Widget>[
            leading,
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: mini ? 10 : 15),
                padding: EdgeInsets.symmetric(vertical: mini ? 3 : 20),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: kSeparatorColor))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        title,
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            icon,
                            subtitle,
                          ],
                        )
                      ],
                    ),
                    trailing,
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}