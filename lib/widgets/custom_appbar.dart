import 'package:flutter/material.dart';
import 'package:video_call_app/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.title,
    required this.actions,
    required this.leading,
    required this.centerTitle,
  });

  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kBackgroundColor,
          border: Border(
              bottom: BorderSide(
            color: kSeparatorColor,
            width: 1.4,
            style: BorderStyle.solid,
          ))),
      child: AppBar(
        elevation: 0,
        leadingWidth: 40,
        titleSpacing: 10,
        backgroundColor: kBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: leading,
        ),
        actions: actions,
        centerTitle: centerTitle,
        title: title,
      ),
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);
}
