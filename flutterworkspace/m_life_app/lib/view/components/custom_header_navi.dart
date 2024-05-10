import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/post/home_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Get.off(() => HomePage()),
      ),
      centerTitle: true,
      title: Text("$title"),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
