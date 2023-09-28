import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:scribble_game/models/touchPoint.dart';

class MyCustomPainter extends CustomPainter {
  MyCustomPainter({required this.pointsList});
  List<touchPoints> pointsList;
  List<Offset> offsetPoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    canvas.clipRect(rect);

    // Check if pointsList is empty
    if (pointsList.isEmpty) {
      return; // Return early if there are no points to draw
    }

    // pointsList contains all the points drawn on the screen , we are using for loop and connecting all the points to draw a line

    for (int i = 0; i < pointsList.length - 1; i++) {
      // ignore: unnecessary_null_comparison
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        // This is a line
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
        // ignore: unnecessary_null_comparison
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        // This is a point
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));

        canvas.drawPoints(
            ui.PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
