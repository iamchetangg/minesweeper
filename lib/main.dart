import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game/main/controller.dart';
import 'game/ui/home.screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameController(),
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: "Molot",
            colorScheme: const ColorScheme.light(
                primary: Colors.brown, onPrimary: Colors.white)),
        home: const HomeScreen(),
      ),
    ),
  );
}
