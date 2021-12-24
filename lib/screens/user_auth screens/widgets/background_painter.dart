import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_call_app/constants.dart';

class BackgroundPainter extends CustomPainter {
  BackgroundPainter({
    Animation<double>? animation,
  })  : bluePaint = Paint()
          ..color = kLightBlueColor
          ..style = PaintingStyle.fill,
        greyPaint = Paint()
          ..color = kBlueColor
          ..style = PaintingStyle.fill,
        orangePaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill,
        linePaint = Paint()
          ..color = Colors.white54
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
        liquidAnim = CurvedAnimation(
          curve: Curves.elasticOut,
          reverseCurve: Curves.easeInBack,
          parent: animation!,
        ),
        orangeAnim = CurvedAnimation(
          parent: animation,
          curve: const Interval(
            0,
            0.7,
            curve: Interval(0, 0.8, curve: SpringCurve()),
          ),
          reverseCurve: Curves.linear,
        ),
        greyAnim = CurvedAnimation(
          parent: animation,
          curve: const Interval(
            0,
            0.8,
            curve: Interval(0, 0.9, curve: SpringCurve()),
          ),
          reverseCurve: Curves.easeInCirc,
        ),
        blueAnim = CurvedAnimation(
          parent: animation,
          curve: const SpringCurve(),
          reverseCurve: Curves.easeInCirc,
        ),
        super(repaint: animation);

  final Animation<double> liquidAnim;
  final Animation<double> blueAnim;
  final Animation<double> greyAnim;
  final Animation<double> orangeAnim;

  final Paint linePaint;
  final Paint bluePaint;
  final Paint greyPaint;
  final Paint orangePaint;

  void _addPointsToPath(Path path, List<Point> points) {
    if (points.length < 3) {
      throw UnsupportedError('Need three or more points to create a path.');
    }

    for (var i = 0; i < points.length - 2; i++) {
      final xc = (points[i].x + points[i + 1].x) / 2;
      final yc = (points[i].y + points[i + 1].y) / 2;
      path.quadraticBezierTo(points[i].x, points[i].y, xc, yc);
    }

    // connect the last two points
    path.quadraticBezierTo(
        points[points.length - 2].x,
        points[points.length - 2].y,
        points[points.length - 1].x,
        points[points.length - 1].y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintBlue(size, canvas);

    paintGrey(size, canvas);

    paintOrange(size, canvas);
  }

  void paintBlue(Size size, Canvas canvas) {
    double h = size.height;
    double w = size.width;

    final path = Path();
    path.moveTo(w, h / 2);
    path.lineTo(w, 0);
    path.lineTo(0, 0);
    path.lineTo(
      0,
      lerpDouble(0, h, blueAnim.value)!,
    );
    _addPointsToPath(path, [
      Point(
        lerpDouble(0, w / 3, blueAnim.value)!,
        lerpDouble(0, h, blueAnim.value)!,
      ),
      Point(
        lerpDouble(w / 2, w / 4 * 3, liquidAnim.value)!,
        lerpDouble(h / 2, h / 4 * 3, liquidAnim.value)!,
      ),
      Point(
        w,
        lerpDouble(h / 2, h * 3 / 4, liquidAnim.value)!,
      ),
    ]);
    canvas.drawPath(path, bluePaint);
  }

  void paintGrey(Size size, Canvas canvas) {
    double h = size.height;
    double w = size.width;

    final path = Path();
    path.moveTo(w, 300);
    path.lineTo(w, 0);
    path.lineTo(0, 0);
    path.lineTo(
      0,
      lerpDouble(
        h / 4,
        h / 2,
        greyAnim.value,
      )!,
    );
    _addPointsToPath(
      path,
      [
        Point(
          w / 4,
          lerpDouble(h / 2, h * 3 / 4, liquidAnim.value)!,
        ),
        Point(
          w * 3 / 5,
          lerpDouble(h / 4, h / 2, liquidAnim.value)!,
        ),
        Point(
          w * 4 / 5,
          lerpDouble(h / 6, h / 3, greyAnim.value)!,
        ),
        Point(
          w,
          lerpDouble(h / 5, h / 4, greyAnim.value)!,
        ),
      ],
    );

    canvas.drawPath(path, greyPaint);
  }

  void paintOrange(Size size, Canvas canvas) {
    double h = size.height;
    double w = size.width;

    if (orangeAnim.value > 0) {
      final path = Path();

      path.moveTo(w * 3 / 4, 0);
      path.lineTo(0, 0);
      path.lineTo(
        0,
        lerpDouble(0, h / 12, orangeAnim.value)!,
      );

      _addPointsToPath(path, [
        Point(
          w / 7,
          lerpDouble(0, h / 6, liquidAnim.value)!,
        ),
        Point(
          w / 3,
          lerpDouble(0, h / 10, liquidAnim.value)!,
        ),
        Point(
          w / 3 * 2,
          lerpDouble(0, h / 8, liquidAnim.value)!,
        ),
        Point(
          w * 3 / 4,
          0,
        ),
      ]);

      canvas.drawPath(path, orangePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Point {
  final double x;
  final double y;

  Point(this.x, this.y);
}

/// Custom curve to give gooey spring effect
class SpringCurve extends Curve {
  const SpringCurve({
    this.a = 0.15,
    this.w = 19.4,
  });
  final double a;
  final double w;

  @override
  double transformInternal(double t) {
    return (-(pow(e, -t / a) * cos(t * w)) + 1).toDouble();
  }
}
