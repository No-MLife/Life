import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/post/category_page.dart';
import '../pages/post/home_page.dart';
import '../pages/user/user_info.dart';

BottomNavigationBar buildBottomNavigationBar() {
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
