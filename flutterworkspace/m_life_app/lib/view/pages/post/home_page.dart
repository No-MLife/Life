import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/post_controller.dart';
import 'package:m_life_app/controller/user_controller.dart';
import 'package:m_life_app/size.dart';
import 'package:m_life_app/view/pages/post/wrtie_page.dart';
import 'package:m_life_app/view/pages/user/login_page.dart';

import '../../components/buildBottomNavigationBar.dart';
import '../../components/post_item.dart';
import '../../components/ad_banner.dart';
import '../user/user_info.dart';
import 'detail_page.dart';

class HomePage extends StatelessWidget {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  UserController u = Get.put(UserController());
  PostController p = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    p.findallpopular();
    return Scaffold(
      drawer: _navigation(context),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "M-Life",
          style: TextStyle(
            fontFamily: 'CustomFont',
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Obx(
        () => RefreshIndicator(
          key: refreshKey,
          onRefresh: () async {
            await p.findallpopular();
          },
          child: ListView.builder(
            itemCount: p.posts.length + 3, // 구분선 개수 조정
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  height: 70,
                  margin: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.amber[200],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: AdBanner(
                    imagePaths: [
                      'assets/ad1.png',
                      'assets/ad2.png',
                      'assets/ad3.png',
                      'assets/ad4.png',
                    ],
                  ),
                );
              } else if (index == 1) {
                return Container(
                  padding: EdgeInsets.all(1.0),
                  color: Colors.white,
                  child: Text(
                    '🔥 인기 게시글',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                );
              } else if (index == 2) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Divider(
                    color: Colors.grey[400],
                    thickness: 1.0,
                  ),
                );
              }

              final itemIndex = index - 3; // 구분선을 고려하여 인덱스 조정
              final post = p.posts[itemIndex];

              return Column(
                children: [
                  PostItem(
                    post: post,
                    onTap: () async {
                      await p.findByid(post.id!);
                      Get.to(() => DetailPage(post.id), arguments: "매개변수 테스트용");
                    },
                    showCategory: true,
                  ),
                  if (itemIndex < p.posts.length - 1) Divider(),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => WritePage());
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.amber,
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget _navigation(BuildContext context) {
    return Container(
      width: getDrawerWidth(context),
      color: Colors.grey[100],
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
                    color: Colors.black,
                  ),
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
                    color: Colors.black,
                  ),
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
                    color: Colors.black,
                  ),
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
