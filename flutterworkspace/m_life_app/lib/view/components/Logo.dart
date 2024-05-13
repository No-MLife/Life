import 'package:flutter/material.dart';

import '../../size.dart';

class Logo extends StatelessWidget {
  final String title;
  final String size;
  const Logo(this.title, this.size);

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        Image.asset(
          "assets/copy_logo.png",
          height: size=="small" ? 150 : 250,
          width: size=="small" ? 150 : 250,
          color: Colors.amber,
        ),
        SizedBox(height: size== "small" ? small_gap : large_gap),
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