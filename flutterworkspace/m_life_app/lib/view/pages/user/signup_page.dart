import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/util/validator_util.dart';
import '../../../size.dart';
import '../../components/Logo.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_text_form_field.dart';
import 'login_page.dart';

class SignupPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

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
      key: _formKey,
      child: Column(
        children: [
          CustomTextFormField(
            text: "아이디",
            funValidator: validate_username(),
          ),
          CustomTextFormField(
            text: "비밀번호",
            funValidator: validate_password(),
          ),
          CustomTextFormField(
            text: "닉네임",
            funValidator: validate_nickname(),
          ),
          CustomTextFormField(
            text: "이메일",
            funValidator: validate_email(),
          ),
          SizedBox(height: large_gap),
          CustomElevatedButton(
            text: "회원가입",
            destination: () {
              if (_formKey.currentState!.validate()) {
                Get.to(() => LoginPage());
              }
            },
          ),
          TextButton(
            onPressed: () {
              Get.to(() => LoginPage());
            },
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                text: "이미 ",
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: "회원가입",
                style: TextStyle(color: Colors.amber),
              ),
              TextSpan(
                text: "이 되어 있나요? ",
                style: TextStyle(color: Colors.black),
              )
            ])),
          )
        ],
      ),
    );
  }
}
