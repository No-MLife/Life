import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/domain/user/user_repository.dart';
import 'package:m_life_app/util/validator_util.dart';
import 'package:m_life_app/view/components/responsive_container.dart';
import '../../../size.dart';
import '../../components/logo.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_text_form_field.dart';
import 'login_page.dart';

class SignupPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final _username = TextEditingController();
  final _password = TextEditingController();
  final _nickname = TextEditingController();
  final _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: large_gap),
          Logo("회원가입", "small"),
          _joinForm(context),
        ],
      ),
    );
  }

  Widget _joinForm(BuildContext context) {
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
              controller: _email,
              text: "이메일",
              funValidator: validate_email(),
            ),
            SizedBox(height: large_gap),
            CustomElevatedButton(
              text: "회원가입",
              destination: () async {
                if (_formKey.currentState!.validate()) {
                  UserRepository u = UserRepository();
                  var response = await u.signup(
                      _username.text.trim(),
                      _password.text.trim(),
                      _nickname.text.trim(),
                      _email.text.trim());
                  if (response!['success'] == true) {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "회원가입 결과",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                response['message'],
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 24),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "확인",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Get.off(() => LoginPage());
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "회원가입 실패",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                response['message'],
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 24),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "확인",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
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
