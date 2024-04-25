import 'package:flutter/material.dart';
import 'package:m_life_app/size.dart';

class CustomTextFormField extends StatelessWidget {
  final String text;

  const CustomTextFormField({required this.text});


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
            validator: (value){
              if(value == null || value.isEmpty){
                return "아이디 또는 비밀번호를 입력해주세요";
              }else{
                return null;
              }
            },

            obscureText: text == "Password" ? true : false,
            decoration: InputDecoration(
              hintText: "Enter Your $text",
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
