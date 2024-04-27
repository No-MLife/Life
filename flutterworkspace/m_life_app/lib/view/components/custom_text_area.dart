import 'package:flutter/material.dart';
import 'package:m_life_app/size.dart';

class CustomTextFormArea extends StatelessWidget {
  final String text;
  final funValidator;
  final String? value;

  const CustomTextFormArea({required this.text, this.funValidator, this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$text"),
        const SizedBox(height: small_gap),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextFormField(
            initialValue: value ?? "",
            maxLines: 10,
            validator: funValidator,
            decoration: InputDecoration(
              hintText: "$text 입력란",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
