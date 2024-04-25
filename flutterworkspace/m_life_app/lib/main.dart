import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/pages/post/home_page.dart';
import 'package:m_life_app/pages/user/login_page.dart';
import 'package:m_life_app/pages/user/signup_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Get.testMode = true;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // 라우트 설계 필요없이 GetX를 이용
      home: SignupPage(

      ),
    );
  }
}
