import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/custom_header_navi.dart';
import 'home_page.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "M-Life"),
      body: Text("카테고리별 게시판"),
    );
  }
}
