import 'package:flutter/material.dart';
import 'package:first_app/gradient_container.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: GradientContainer(Color.fromARGB(255, 143, 35, 114),
            Color.fromARGB(255, 186, 108, 165)),
      ),
    ),
  );
}
