import 'dart:math';

class Cell {
  final Point loc;
  bool hasBomb;
  bool hadBomb;
  bool hasPiece;
  bool autoDiscovered;
  int adjacentCount;
  bool showAdjacentNumber;
  Cell({
    required this.loc,
    this.hasBomb = false,
    this.hadBomb = false,
    this.hasPiece = false,
    this.autoDiscovered = false,
    this.adjacentCount = 0,
    this.showAdjacentNumber = false,
  });
}
