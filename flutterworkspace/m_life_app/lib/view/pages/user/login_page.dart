import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/util/validator_util.dart';
import 'package:m_life_app/view/components/myBannerAdWidget.dart';
import 'package:m_life_app/view/pages/post/home_page.dart';
import 'package:m_life_app/view/pages/user/signup_page.dart';
import '../../../controller/user_controller.dart';
import '../../components/logo.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_text_form_field.dart';
import 'package:m_life_app/size.dart';

import '../../components/responsive_container.dart';

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
          SizedBox(height: 70),
          Logo("로그인", "large"),
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return ResponsiveContainer(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  String token = await u.login(
                      _username.text.trim(), _password.text.trim());
                  if (token != "-1") {
                    print("토큰을 정상적으로 받았습니다.");
                    u.getProfile(u.principal.value.nickname!);
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
                                "로그인 성공",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "로그인 되었습니다.",
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
                                  Get.off(() => HomePage());
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
                                "로그인",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "아이디 또는 비밀번호를 확인해주세요.",
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
                Get.to(() => SignupPage());
              },
              child: RichText(
                text: TextSpan(
                  children: [
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
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
