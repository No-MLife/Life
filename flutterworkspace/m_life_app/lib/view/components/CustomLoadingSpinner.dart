import 'package:flutter/material.dart';

class CustomLoadingSpinner extends StatelessWidget {
  final double size;

  const CustomLoadingSpinner({Key? key, this.size = 50.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
          strokeWidth: 5.0,
        ),
      ),
    );
  }
}
