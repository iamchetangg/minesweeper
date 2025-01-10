import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/constants.dart';
import '../main/controller.dart';
import '../main/screen.dart';

// ignore: must_be_immutable
class GameCreationScreen extends StatelessWidget {
  GameCreationScreen({super.key});

  var boardSize = 10;
  var bombs = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.brown,
        child: SafeArea(
            child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Image.asset("assets/newgame.png"),
            ),
            Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Grid Size",
                          style: Constants.textStyle,
                        ),
                        StatefulBuilder(builder: (context, state) {
                          return DropdownButton<int>(
                              value: boardSize,
                              iconEnabledColor: Colors.white,
                              iconDisabledColor: Colors.white,
                              style: Constants.textStyle,
                              underline: Container(),
                              dropdownColor: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                              items: [8, 10, 12]
                                  .map((e) => DropdownMenuItem(
                                        child: Text("$e"),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (v) {
                                state(() {
                                  boardSize = v ?? 10;
                                });
                              });
                        }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Bombs",
                          style: Constants.textStyle,
                        ),
                        StatefulBuilder(builder: (context, state) {
                          return DropdownButton<int>(
                              value: bombs,
                              iconEnabledColor: Colors.white,
                              iconDisabledColor: Colors.white,
                              style: Constants.textStyle,
                              underline: Container(),
                              dropdownColor: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                              items: [8 * 2, 10 * 2, 12 * 2]
                                  .map((e) => DropdownMenuItem(
                                        child: Text(
                                          "$e",
                                          style: Constants.textStyle,
                                        ),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (v) {
                                state(() {
                                  bombs = v ?? 20;
                                });
                              });
                        }),
                      ],
                    ),
                    TextButton(
                        onPressed: () {
                          Provider.of<GameController>(context, listen: false)
                              .gridSize = boardSize;
                          Provider.of<GameController>(context, listen: false)
                              .bombCount = bombs;
                          Provider.of<GameController>(context, listen: false)
                              .pieceCount = bombs;
                          Provider.of<GameController>(context, listen: false)
                              .initializeGame();
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => GameScreen()));
                        },
                        child: Text(
                          "PLAY",
                          style: Constants.textStyle,
                        )),
                    // TextButton(onPressed: () {

                    // }, child: Text("Continue")),
                    // TextButton(onPressed: () {}, child: Text("QUIT")),
                  ],
                ))
          ],
        )),
      ),
    );
  }
}
