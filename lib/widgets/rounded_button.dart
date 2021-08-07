import 'package:flutter/material.dart';

import '../constants.dart';

class RoundedMaterialButton extends StatelessWidget {
  RoundedMaterialButton(
      {required this.onPressed, required this.title, required this.icon});

  final Function() onPressed;
  final String title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
          color: kBlueColor,
          boxShadow: [kSubtleShadow],
          borderRadius: BorderRadius.circular(kUniformBorderRadius)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(kUniformBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              SizedBox(width: 7),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
