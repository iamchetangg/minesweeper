import 'dart:math';

import 'package:flutter/material.dart';

import '../helpers/constants.dart';
import '../helpers/extensions.dart';
import 'create.screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<Widget> generateMines(BuildContext context) {
    var list = <Widget>[];
    for (int i = 0; i < 16; i++) {
      list.add(Positioned(
          left: Random()
              .nextInt(MediaQuery.sizeOf(context).width.toInt())
              .toDouble(),
          top: Random()
              .nextInt(MediaQuery.sizeOf(context).height.toInt())
              .toDouble(),
          child: Image.asset("assets/mine.png",
              scale: Random().nextDouble() * 5,
              color: [
                Colors.brown.shade600,
                Colors.brown.shade200,
                Colors.brown.shade800
              ].random)));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.brown,
        child: SafeArea(
            child: Stack(
          children: [
            ...generateMines(context),
            Center(
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Image.asset("assets/title.png"),
                  ),
                  Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                              onPressed: () {
                                // Provider.of<GameController>(context, listen: false)
                                //     .initializeGame();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => GameCreationScreen()));
                              },
                              child: const Text(
                                "PLAY",
                                style: Constants.textStyle,
                              )),

                          // TextButton(
                          //     onPressed: () {},
                          //     child: Text(
                          //       "QUIT",
                          //       style: textStyle,
                          //     )),
                        ],
                      ))
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
