import 'package:flutter/material.dart';
import 'package:m_life_app/size.dart';

class CustomTextFormField extends StatelessWidget {
  final String text;
  final funValidator;

  const CustomTextFormField({required this.text, this.funValidator});


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
            validator: funValidator,
            obscureText: text == "비밀번호" ? true : false,
            decoration: InputDecoration(
              hintText: "$text 입력란",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),

      ],
    );
  }
}
