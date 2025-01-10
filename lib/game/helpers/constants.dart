import 'dart:math';

import 'package:flutter/material.dart';

class Constants {
  static const List<Point<int>> directions = [
    Point(-1, -1), // Top-left
    Point(-1, 0), // Top
    Point(-1, 1), // Top-right
    Point(0, -1), // Left
    Point(0, 1), // Right
    Point(1, -1), // Bottom-left
    Point(1, 0), // Bottom
    Point(1, 1), // Bottom-right
  ];

  static const textStyle =
      TextStyle(fontSize: 26, letterSpacing: 1.3, color: Colors.white);
}
