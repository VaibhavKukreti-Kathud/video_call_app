import 'package:flutter/material.dart';

double kUniformBorderRadius = 20;
double kFontSize = 12;
BoxShadow kSubtleShadow = BoxShadow(
    offset: Offset(0, -10),
    spreadRadius: 2,
    blurRadius: 15,
    color: Colors.black.withOpacity(0.5));

Color kBlueColor = Color(0xff2b9ed4);
Color kBackgroundColor = Color(0xff19191b);
Color kGreyColor = Color(0xff8f8f8f);
Color kUserCircleBackground = Color(0xff2b2b33);
Color kOnlineDotColor = Color(0xff46dc64);
Color kLightBlueColor = Color(0xff0077d7);
Color kSeparatorColor = Color(0xff272c35);
Color kGradientColorStart = Color(0xff00b6f3);
Color kGradientColorEnd = Color(0xff0184dc);
Color kSenderColor = Color(0xff2b343b);
Color kReceiverColor = Color(0xff1e2225);
Color kIconColor = Colors.white;

Gradient kFabGradient = LinearGradient(
    colors: [kGradientColorStart, kGradientColorEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight);
