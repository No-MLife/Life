import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/user_controller.dart';
import 'package:m_life_app/view/pages/user/login_page.dart';

import '../../components/custom_header_navi.dart';

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserController u = Get.find();
    return Scaffold(
      appBar: CustomAppBar(
        title: 'M-Life',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("회원 번호 "),
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Get.off(() => LoginPage()),
            )
          ],
        ),
      ),
    );
  }
}
