import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/components/custom_text_form_field.dart';
import 'package:m_life_app/pages/user/login_page.dart';
import '../../components/Logo.dart';
import '../../components/custom_elevated_button.dart';
import '../../size.dart';

class SignupPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: large_gap),
          Logo("회원가입", "small"),
          _joinForm(),

        ],
      ),
    );
  }

  Widget _joinForm() {
    return Form(
          child: Column(
            children: [
              CustomTextFormField(text: "NickName"),
              CustomTextFormField(text: "ID"),
              CustomTextFormField(text: "Password"),
              CustomTextFormField(text: "Password"),
              SizedBox(height: large_gap),
              CustomElevatedButton(
                text: "회원가입",
                destination: () => Get.to(LoginPage()),),

            ],
          ),
        );
  }
}

