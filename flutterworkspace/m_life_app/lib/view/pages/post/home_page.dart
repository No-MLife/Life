import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/post_controller.dart';
import 'package:m_life_app/controller/user_controller.dart';
import 'package:m_life_app/size.dart';
import 'package:m_life_app/view/components/custom_header_navi.dart';
import 'package:m_life_app/view/pages/post/category_page.dart';
import 'package:m_life_app/view/pages/post/wrtie_page.dart';
import 'package:m_life_app/view/pages/user/login_page.dart';

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
      appBar: CustomAppBar(
        title: 'M-Life',
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
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () async {
                          await p.findByid(post.id!);
                          Get.to(() => DetailPage(post.id),
                              arguments: "매개변수 테스트용");
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/logo.png",
                                      height: 45,
                                      width: 45,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "${post.authorName} ${post.likeCount}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "[자유게시판]",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "${post.title}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Text(
                                        "댓글 ${post.commentList!.length}  ",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "좋아요 ${post.likeCount}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (itemIndex < p.posts.length - 1) SizedBox(height: 8),
                  ],
                );
              },
            ),
          )),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Get.to(() => WritePage());
      },
      child: Icon(Icons.create_rounded),
      backgroundColor: Colors.amber,
      foregroundColor: Colors.black,
      shape: CircleBorder(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: '인기 게시글',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: '게시판 카테고리',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '회원정보',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Get.off(() => HomePage());
          } else if (index == 1) {
            Get.off(() => CategoryPage());
          } else {
            Get.off(() => UserInfo());
          }
        },
        backgroundColor: Colors.amber);
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
