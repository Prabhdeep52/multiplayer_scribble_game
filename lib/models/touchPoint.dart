import 'package:flutter/material.dart';

class touchPoints {
  Paint paint;
  Offset points;
  touchPoints({required this.paint, required this.points});

  Map<String, dynamic> toJson() {
    return {
      'point': {'dx': '${points.dx}', "dy": "${points.dy}"}
    };
  }
}
