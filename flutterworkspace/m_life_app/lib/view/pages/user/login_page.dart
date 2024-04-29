import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/util/validator_util.dart';
import 'package:m_life_app/view/pages/post/home_page.dart';
import 'package:m_life_app/view/pages/user/signup_page.dart';
import '../../../controller/user_controller.dart';
import '../../components/Logo.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_text_form_field.dart';
import 'package:m_life_app/size.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final UserController u = Get.put(UserController());

  final _username = TextEditingController();
  final _password = TextEditingController();

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
            controller: _username,
            text: "아이디",
            funValidator: validate_username(),
          ),
          CustomTextFormField(
            controller: _password,
            text: "비밀번호",
            funValidator: validate_password(),
          ),
          SizedBox(height: medium_gap),
          CustomElevatedButton(
            text: "로그인",
            destination: () async {
              if (_formKey.currentState!.validate()) {
                String token =
                    await u.login(_username.text.trim(), _password.text.trim());
                if (token != "-1") {
                  print("토큰을 정상적으로 받았습니다.");
                  Get.off(() => HomePage());
                } else {
                  print("토큰을 정상적으로 받지 못했습니다.");
                }
              }
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