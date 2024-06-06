import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/user_controller.dart';
import 'package:m_life_app/view/pages/user/login_page.dart';
import 'package:m_life_app/view/pages/post/home_page.dart'; // 로그인이 되었을 때 이동할 홈 페이지
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // FlutterSecureStorage 추가

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final UserController _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    Get.testMode = true;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // 로딩 스피너
          } else {
            if (snapshot.hasData && snapshot.data == true) {
              print("로그인 확인");
              return HomePage(); // 로그인이 되어 있을 경우 홈 페이지로 이동
            } else {
              print("로그인 필요");
              return LoginPage(); // 로그인 페이지로 이동
            }
          }
        },
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    String? isLoggedIn = await secureStorage.read(key: 'isLoggedIn');
    if (isLoggedIn == 'true') {
      String? username = await secureStorage.read(key: 'username');
      String? password = await secureStorage.read(key: 'password');
      await _userController.login(username!, password!);
    }
    return isLoggedIn == 'true';
  }
}
