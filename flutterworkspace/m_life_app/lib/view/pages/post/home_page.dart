import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/post_controller.dart';
import 'package:m_life_app/controller/user_controller.dart';
import 'package:m_life_app/size.dart';
import 'package:m_life_app/view/pages/post/wrtie_page.dart';
import 'package:m_life_app/view/pages/user/login_page.dart';

import '../user/user_info.dart';
import 'detail_page.dart';

class HomePage extends StatelessWidget {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  // put은 없으면 만들고 있으면 찾는다.
  UserController u = Get.put(UserController());
  PostController p = Get.put(PostController());
  // UserController u = Get.find();
  @override
  Widget build(BuildContext context) {
    p.findall();
    return Scaffold(
      drawer: _nvaigation(context),
      appBar: AppBar(
        title: Text("M-Life"),
        // title: Obx(() => Text("${u.isLogin}")),
      ),
      body: Obx(() => RefreshIndicator(
            key: refreshKey,
            onRefresh: () async {
              await p.findall();
            },
            child: ListView.separated(
              itemCount: p.posts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    await p.findByid(p.posts[index].id!);
                    Get.to(() => DetailPage(p.posts[index].id),
                        arguments: "매개변수 테스트용");
                  },
                  title: Text("${p.posts[index].title}"),
                  leading: Text("${p.posts[index].id}"),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          )),
    );
  }

  Widget _nvaigation(BuildContext context) {
    return Container(
      width: getDrawerWidth(context),
      height: double.infinity,
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  Get.to(() => WritePage());
                },
                child: Text(
                  "글쓰기",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              Divider(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Get.to(() => UserInfo());
                },
                child: Text(
                  "회원정보보기",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              Divider(),
              TextButton(
                onPressed: () {
                  u.logout();
                  Get.off(() => LoginPage());
                  print("로그아웃 되었습니다.");
                },
                child: Text(
                  "로그아웃",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
