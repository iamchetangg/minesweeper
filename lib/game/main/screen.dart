// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/constants.dart';
import 'board.dart';
import 'controller.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTimer();
    });
  }

  Timer? timer;

  void _startTimer() {
    final gameController = Provider.of<GameController>(context, listen: false);
    timer = Timer.periodic(const Duration(seconds: 10), (_timer) {
      if (gameController.gameOver) {
        _timer.cancel();
        showDialog(
            context: context,
            builder: (_) {
              return Center(
                child: Container(
                  height: 250,
                  width: 350,
                  child: Dialog(
                    backgroundColor: Colors.brown,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Game Over!",
                            style: Constants.textStyle.copyWith(fontSize: 30),
                          ),
                          SizedBox(
                            height: 30,
                            child: Text("Score: ${calculateScore()}",
                                style:
                                    Constants.textStyle.copyWith(fontSize: 24)),
                          ),
                          TextButton(
                              onPressed: () {
                                Provider.of<GameController>(context,
                                        listen: false)
                                    .reset();
                                Navigator.of(context)
                                    .popUntil((r) => r.isFirst);
                              },
                              child: Text(
                                "Reset",
                                style:
                                    Constants.textStyle.copyWith(fontSize: 22),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
      } else {
        gameController.explodeRandomBomb();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context, listen: false);

    return PopScope(
      onPopInvoked: (_) {
        Provider.of<GameController>(context, listen: false).reset();
        timer?.cancel();
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text('${gameController.gridSize} x ${gameController.gridSize}',
              style: Constants.textStyle),
          backgroundColor: Colors.brown,
        ),
        backgroundColor: Colors.brown.shade200,
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color(0xFF795548),
              borderRadius: BorderRadius.circular(10)),
          height: 80,
          width: MediaQuery.sizeOf(context).width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Center(
                    child: Container(
                      width: 80,
                      height: 90,
                      margin: const EdgeInsets.all(10),
                      // color: Colors.amber,
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: getPieceStackItems(),
                      ),
                    ),
                  ),
                  Text(
                      Provider.of<GameController>(context)
                          .pieceCount
                          .toString(),
                      style:
                          const TextStyle(fontSize: 32, color: Colors.white)),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    "assets/mine.png",
                    color: Colors.red,
                    width: 30,
                    height: 30,
                  ),
                  Text(" ${Provider.of<GameController>(context).bombCount} ",
                      style:
                          const TextStyle(fontSize: 32, color: Colors.white)),
                ],
              )
            ],
          ),
          /*    child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.4, crossAxisCount: 6),
                  scrollDirection: Axis.vertical,
                  itemCount: Provider.of<GameController>(context).pieceCount,
                  itemBuilder: (context, index) => GamePiece(),
                ), */
        ),
        body: Column(
          children: [
            const Expanded(child: GameBoard()),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Your Score : ${calculateScore()} ",
                    style: const TextStyle(
                        color: Colors.brown,
                        fontSize: 26,
                        fontWeight: FontWeight.bold)),
                WidgetSpan(
                    child: Image.asset(
                  "assets/mine.png",
                  color: Colors.black,
                  width: 26,
                  height: 26,
                )),
              ])),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(children: [
                  const WidgetSpan(
                      child: Icon(
                    Icons.info_outline_rounded,
                    color: Colors.brown,
                    size: 20,
                  )),
                  const TextSpan(
                      text:
                          " Your score is based upon the bombs discovered by you, marked with ",
                      style: TextStyle(
                          color: Colors.brown,
                          fontSize: 16,
                          fontWeight: FontWeight.normal)),
                  WidgetSpan(
                      child: Image.asset(
                    "assets/mine.png",
                    color: Colors.black,
                    width: 16,
                    height: 16,
                  )),
                  const TextSpan(
                      text: " icon.",
                      style: TextStyle(
                          color: Colors.brown,
                          fontSize: 16,
                          fontWeight: FontWeight.normal)),
                ]),
                textAlign: TextAlign.center,
              ),
            ),
            /* Expanded(
              flex: 1,
              child: ), */
          ],
        ),
      ),
    );
  }

  List<Widget> getPieceStackItems() {
    var list = <Widget>[];
    for (int i = 0; i < Provider.of<GameController>(context).pieceCount; i++) {
      list.add(
        Transform.translate(
            offset: Offset(1.0 * i, -0.8 * i), // Offset(x, y)
            child: GamePiece(i: i)
            /*    child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              boxShadow: [
                BoxShadow(blurRadius: 6, spreadRadius: 2, color: const Color.fromARGB(31, 145, 126, 126))
              ],
              color: Colors.accents[(i * 0.5).toInt()],
            ),
          ), */
            ),
        /*   Positioned(
          // offset: Offset(10.0, 14.0), // Offset(x, y)
          left: (10 * i).toDouble(),
          right: MediaQuery.of(context).size.width * 0.9,
          child: Container(
            width: 50,
            height: 50,
            color: Colors.accents[(i * 0.1).toInt()].withOpacity(0.5),
          ),
        ), */
      );
    }
    return list;
  }

  calculateScore() {
    final gameController = Provider.of<GameController>(context, listen: true);
    var score = 0;
    for (int i = 0; i < gameController.cells.length; i++) {
      for (int j = 0; j < gameController.cells[i].length; j++) {
        if (gameController.cells[i][j].hasPiece == true &&
            gameController.cells[i][j].hadBomb) {
          score++;
        }
      }
    }
    return score;
  }
}
