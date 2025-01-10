import 'dart:math';

import 'package:flutter/material.dart';

import '../data/cell.class.dart';
import '../helpers/constants.dart';

class GameController with ChangeNotifier {
  int gridSize = 10;
  int bombCount = 20;
  int pieceCount = 20;

  int discoveredBombs = 0;
  int explodedBombs = 0;
  bool gameOver = false;
  late List<List<Cell>> cells;

  GameController() {
    initializeGame();
    gameOver = false;
  }

  void reset() {
    discoveredBombs = 0;
    explodedBombs = 0;
    gameOver = false;
    cells.clear();
  }

  void initializeGame() {
    cells = List.generate(
        gridSize, (i) => List.filled(gridSize, Cell(loc: const Point(0, 0))));
    for (int x = 0; x < gridSize; x++) {
      for (int y = 0; y < gridSize; y++) {
        cells[x][y] = Cell(loc: Point(x, y));
      }
    }

    _placeBombs();
  }

  void _placeBombs() {
    final random = Random();
    int placedBombs = 0;
    while (placedBombs < bombCount) {
      int x = random.nextInt(gridSize);
      int y = random.nextInt(gridSize);
      if (!cells[x][y].hasBomb) {
        cells[x][y].hadBomb = true;
        cells[x][y].hasBomb = true;

        // print("BOMB AT $x, $y");
        placedBombs++;
      }
    }
    for (int x = 0; x < gridSize; x++) {
      for (int y = 0; y < gridSize; y++) {
        var c = countAdjacentMines(x, y).reduce((a, b) => a + b);
        cells[x][y].adjacentCount = c;
      }
    }
  }

  bool placePiece(int x, int y) {
    if (cells[x][y].hasPiece) return false;
    if (cells[x][y].hasBomb) {
      discoveredBombs++;
      cells[x][y].hasPiece = true;
      cells[x][y].hasBomb = false;

      notifyListeners();
      return true;
    }
    cells[x][y].hasPiece = true;
    cells[x][y].showAdjacentNumber = true;

    doChording(x, y);
    pieceCount--;
    if (pieceCount == 0) {
      gameOver = true;
    }
    notifyListeners();
    return true;
  }

  void doChording(int x, int y) {
    var mc = cells[x][y].adjacentCount;
    var b = cells[x][y].hasBomb;
    if (b) {
      return;
    } else if (mc > 0) {
      return;
    } else if (mc == 0) {
      for (int i = 0; i < Constants.directions.length; i++) {
        int newX = x + Constants.directions[i].x;
        int newY = y + Constants.directions[i].y;

        if (newX >= 0 && newX < gridSize && newY >= 0 && newY < gridSize) {
          if (cells[newX][newY].adjacentCount == 0) {
            if (!cells[newX][newY].hasPiece) {
              cells[newX][newY].hasPiece = true;
              doChording(newX, newY);
            }
          } else {
            cells[newX][newY].showAdjacentNumber = true;
            cells[newX][newY].hasPiece = true;
            // return;
          }
        }
      }
    }
  }

  void explodeRandomBomb() {
    if (gameOver) return;
    final random = Random();
    List<Point<int>> remainingBombs = [];
    for (int x = 0; x < gridSize; x++) {
      for (int y = 0; y < gridSize; y++) {
        if (cells[x][y].hasBomb) remainingBombs.add(Point(x, y));
      }
    }
    if (remainingBombs.isNotEmpty) {
      Point<int> bomb = remainingBombs[random.nextInt(remainingBombs.length)];
      cells[bomb.x][bomb.y].hasBomb = false;
      cells[bomb.x][bomb.y].autoDiscovered = true;
      explodedBombs++;
      notifyListeners();
    }
    if (remainingBombs.length <= 1) endGame();
  }

  void endGame() {
    gameOver = true;
    notifyListeners();
  }

  List<int> countAdjacentMines(int x, int y) {
    List<int> mineCounts = List.filled(8, 0);

    for (int i = 0; i < Constants.directions.length; i++) {
      int newX = x + Constants.directions[i].x;
      int newY = y + Constants.directions[i].y;

      if (newX >= 0 && newX < gridSize && newY >= 0 && newY < gridSize) {
        if (cells[newX][newY].hasBomb) {
          mineCounts[i]++;
        }
      }
    }

    return mineCounts;
  }
}
