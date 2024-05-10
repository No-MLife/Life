import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/post/category_page.dart';
import '../pages/post/home_page.dart';
import '../pages/user/user_info.dart';

class CustomBottomNavBarController extends GetxController {
  final _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  void updateIndex(int index) {
    _currentIndex.value = index;
    _navigateTo(index);
  }

  void _navigateTo(int index) {
    switch (index) {
      case 0:
        Get.to(() => HomePage());
        break;
      case 1:
        Get.to(() => CategoryPage());
        break;
      case 2:
        Get.to(() => UserInfo());
        break;
    }
  }}

class buildBottomNavigationBar extends StatelessWidget {
  final controller = Get.put(CustomBottomNavBarController());

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '인기 게시글',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: '게시판 카테고리',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '회원정보',
          ),
        ],
        currentIndex: controller.currentIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey[600],
        onTap: controller.updateIndex,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 8.0,
      ),
    );
  }
}