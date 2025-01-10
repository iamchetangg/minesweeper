import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

Color prevColor = Colors.blue;

class _GameBoardState extends State<GameBoard> {
  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context);
    /*    final colorList =
        generateColorSwatch(Colors.blue, gameController.pieceCount + 1)
            .reversed
            .toList(); */
    return GridView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gameController.gridSize),
      itemCount: gameController.gridSize * gameController.gridSize,
      itemBuilder: (context, index) {
        int x = index ~/ gameController.gridSize;
        int y = index % gameController.gridSize;
        var cell = gameController.cells[x][y];
        bool hasPiece = cell.hasPiece;
        bool autoDiscoveredBomb = cell.autoDiscovered;
       
        bool hadBomb = cell.hadBomb;
        bool showAdjNum = cell.showAdjacentNumber;
        // var mineCounts = gameController.cells;
        // var showNumbers = gameController.showNumbers;

        
        return DragTarget<int>(
          builder: (context, candidateData, rejectedData) {
            return AnimatedContainer(
                duration: Duration(milliseconds: 400 + ((x) * 70)),
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: hasPiece
                      // ? colorList[pieceCount] // Piece placed
                      ? Colors.white
                      : autoDiscoveredBomb
                          ? Colors.transparent // Auto-discovered bomb

                          : Colors.brown, // Default empty cell
                  // border: hasBomb ? Border.all() : null,
                ),
                child: Stack(children: [
                  autoDiscoveredBomb || (hadBomb && hasPiece)
                      ? Center(
                          child: Image.asset(
                            "assets/mine.png",
                            color: hasPiece ? Colors.black : Colors.red,
                            width: 30,
                            height: 30,
                          ),
                        )
                      : Container(),
                  if (!hadBomb &&
                      cell.adjacentCount > 0 &&
                      hasPiece &&
                      showAdjNum)
                    Center(
                      child: Text(
                        cell.adjacentCount.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                ]));
          },
          onWillAcceptWithDetails: (data) {
            return !hasPiece && !autoDiscoveredBomb;
          },
          onAcceptWithDetails: (data) {
            setState(() {
              // color = Colors.accents[data.data.clamp(0, 15)];
            });
            gameController.placePiece(x, y);
          },
        );
      },
    );
  }
}

List<Color> generateColorSwatch(Color baseColor, int steps) {
  HSLColor hslColor = HSLColor.fromColor(baseColor);
  List<Color> swatch = [];

  for (int i = 0; i < steps; i++) {
    double lightness = (hslColor.lightness - (i * (hslColor.lightness / steps)))
        .clamp(0.0, 1.0);
    HSLColor adjustedColor = hslColor.withLightness(lightness);
    swatch.add(adjustedColor.toColor());
  }

  return swatch;
}

class GamePiece extends StatelessWidget {
  const GamePiece({super.key, required this.i});
  final int i;
  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context, listen: true);
    final colorList =
        generateColorSwatch(Colors.white, gameController.pieceCount)
            .reversed
            .toList();
    return Draggable<int>(
      data: i,
      feedback: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(blurRadius: 6, spreadRadius: 2, color: Color(0x1F917E7E))
          ],
          color: colorList[i],
        ),
      ),
      childWhenDragging: Container(),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              blurRadius: 6, spreadRadius: 2,
              //  color: Colors.black,
              color: Color.fromARGB(31, 122, 114, 114),
            )
          ],
          color: colorList[i],
        ),
      ),
    );
  }
}
