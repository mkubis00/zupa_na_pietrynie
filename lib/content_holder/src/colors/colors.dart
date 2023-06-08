import 'dart:math';

import 'package:flutter/material.dart';

class AppColors {
  static const Color BLACK = Color.fromARGB(255,41,2,53);
  static const Color WHITE = Colors.white;
  static const Color INDIGO = Colors.indigoAccent;
  static const Color FACEBOOK_BLUE = Colors.blueAccent;
  static const Color RED = Colors.red;
  static const Color GREY = Colors.grey;
  static const Color GREEN = Color.fromARGB(255, 5, 143, 125);
  static const Color GREEN_SHADOW = Color.fromARGB(100, 2, 182, 157);
  static const Color BACKGROUND_COLOR = Color.fromARGB(255, 243, 246, 255);

  static Color randomEventCounterColor() {
    List<Color> colors = [
      Colors.deepOrange,
      Colors.green,
      Colors.deepPurple,
      Colors.black54,
      Colors.teal,
      Colors.red,
      Colors.pinkAccent[700]!,
      Colors.orange.shade900,
      Colors.lime.shade900,
      Colors.green.shade800,
      Colors.lightBlue.shade900,
      Colors.blueGrey.shade700,
      Colors.brown.shade700,
    ];
    Random random = new Random();
    int randomNumber = random.nextInt(colors.length);
    return colors.elementAt(randomNumber);
  }
}