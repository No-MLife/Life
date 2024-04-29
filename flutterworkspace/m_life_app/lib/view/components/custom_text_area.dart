import 'package:flutter/material.dart';
import 'package:m_life_app/size.dart';

class CustomTextFormArea extends StatelessWidget {
  final String text;
  final funValidator;
  final controller;

  const CustomTextFormArea(
      {required this.text, this.funValidator, this.controller});

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(15);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$text"),
        const SizedBox(height: small_gap),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextFormField(
            controller: controller,
            maxLines: 13,
            validator: funValidator,
            decoration: InputDecoration(
              hintText: "$text 입력란",
              enabledBorder: OutlineInputBorder(
                borderRadius: borderRadius,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: borderRadius,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: borderRadius,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: borderRadius,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
