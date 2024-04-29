import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/user_controller.dart';

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserController u = Get.find();
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("회원 번호 ")],
        ),
      ),
    );
  }
}
