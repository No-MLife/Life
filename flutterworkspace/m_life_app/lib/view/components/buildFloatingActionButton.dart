import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/post/wrtie_page.dart';

FloatingActionButton buildFloatingActionButton() {
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
