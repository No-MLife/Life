import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/post_controller.dart';
import 'package:m_life_app/controller/user_controller.dart';
import 'package:m_life_app/size.dart';
import 'package:m_life_app/view/pages/post/wrtie_page.dart';
import 'package:m_life_app/view/pages/user/login_page.dart';

import '../../components/buildBottomNavigationBar.dart';
import '../../components/buildFloatingActionButton.dart';
import '../../components/post_item.dart';
import '../../components/ad_banner.dart';
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
    p.findallpopular();
    return Scaffold(
      drawer: _nvaigation(context),
      appBar: AppBar(
        centerTitle: true,
        title: Text("M-Life"),
      ),
      body: Obx(() => RefreshIndicator(
            key: refreshKey,
            onRefresh: () async {
              await p.findallpopular();
            },
            child: ListView.builder(
              itemCount: p.posts.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    height: 70,
                    margin: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.amber[200],
                      borderRadius: BorderRadius.circular(45.0),
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
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '🔥인기 게시글',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                final itemIndex = index - 2;
                final post = p.posts[itemIndex];

                return Column(
                  children: [
                    PostItem(
                      post: post,
                      onTap: () async {
                        print(post.id);
                        await p.findByid(post.id!);
                        Get.to(() => DetailPage(post.id), arguments: "매개변수 테스트용");
                      },
                      showCategory: true,
                    ),
                    if (itemIndex < p.posts.length - 1) SizedBox(height: 8),
                  ],
                );              },
            ),
          )),
      floatingActionButton: buildFloatingActionButton(),
      bottomNavigationBar: buildBottomNavigationBar(),
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
