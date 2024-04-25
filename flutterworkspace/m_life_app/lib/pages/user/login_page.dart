import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/components/custom_text_form_field.dart';
import 'package:m_life_app/pages/post/home_page.dart';
import '../../components/Logo.dart';
import '../../components/custom_elevated_button.dart';
import '../../size.dart';
import 'package:m_life_app/size.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: large_gap),
          Logo("로그인", "large"),
          _loginForm(),

        ],
      ),
    );
  }

  Widget _loginForm() {
    return Form(
      child: Column(
        children: [
          CustomTextFormField(text: "ID"),
          CustomTextFormField(text: "Password"),
          SizedBox(height: medium_gap),
          CustomElevatedButton(
            text: "로그인",
            destination: () => Get.to(HomePage()),
          ),
        ],
      ),
    );
  }
}

