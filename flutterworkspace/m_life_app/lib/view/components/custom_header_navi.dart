import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool isHome;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBackPressed,
    required this.isHome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: isHome == false ? Icon(Icons.arrow_back) : Icon(Icons.home),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text("$title",
          style: TextStyle(
            fontFamily: 'CustomFont',
            fontSize: 24,
            color: Colors.white,
          )),
      backgroundColor: Colors.amber,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
