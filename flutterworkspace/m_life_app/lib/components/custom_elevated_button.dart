import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/pages/user/login_page.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final destination;

  const CustomElevatedButton({required this.text, required this.destination});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
          minimumSize: Size(double.infinity, 70),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          )
      ),

      onPressed: destination,
      child: Text("$text"),);
  }
}
