import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/domain/user/user_repository.dart';
import 'package:m_life_app/util/validator_util.dart';
import 'package:m_life_app/view/components/responsive_container.dart';
import '../../../size.dart';
import '../../components/Logo.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_text_form_field.dart';
import 'login_page.dart';

class SignupPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final _username = TextEditingController();
  final _password = TextEditingController();
  final _nickname = TextEditingController();

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
    return ResponsiveContainer(
      child: Form(
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
            CustomTextFormField(
              controller: _nickname,
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
              destination: () async {
                if (_formKey.currentState!.validate()) {
                  UserRepository u = UserRepository();
                  bool isSign = await u.signup(_username.text.trim(),
                      _password.text.trim(), _nickname.text.trim());
                  if (isSign) {
                    Get.off(() => LoginPage());
                  } else {
                    print("회원가입에 실패하였습니다.");
                  }
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
      ),
    );
  }
}
