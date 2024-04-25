import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String title;
  final String size;
  const Logo(this.title, this.size);

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        Image.asset(
          "assets/logo.png",
          height: size=="small" ? 100 : 250,
          width: size=="small" ? 120 : 250,
        ),
        Text(
            title,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            )
        ),
      ],
    );
  }
}