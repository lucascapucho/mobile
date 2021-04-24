import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  const BackgroundContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
          Colors.purpleAccent.shade200,
          Colors.purpleAccent.shade400,
          Colors.purple,
          Colors.purple.shade800
        ])));
  }
}
