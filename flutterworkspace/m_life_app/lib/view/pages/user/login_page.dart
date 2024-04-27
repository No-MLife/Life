import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/util/validator_util.dart';
import 'package:m_life_app/view/pages/user/signup_page.dart';
import '../../components/Logo.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_text_form_field.dart';
import 'package:m_life_app/size.dart';

import '../post/home_page.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

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
      key: _formKey,
      child: Column(
        children: [
          CustomTextFormField(
            text: "ID",
            funValidator: validate_username(),
          ),
          CustomTextFormField(
            text: "Password",
            funValidator: validate_password(),
          ),
          SizedBox(height: medium_gap),
          CustomElevatedButton(
            text: "로그인",
            destination: () {
              if (_formKey.currentState!.validate()) Get.to(() => HomePage());
            },
          ),
          TextButton(
            onPressed: () {
              Get.to(() => SignupPage());
            },
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                text: "아직 ",
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: "회원가입",
                style: TextStyle(color: Colors.amber),
              ),
              TextSpan(
                text: "이 되어 있지 않나요? ",
                style: TextStyle(color: Colors.black),
              )
            ])),
          )
        ],
      ),
    );
  }
}
