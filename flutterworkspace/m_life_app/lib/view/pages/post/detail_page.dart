import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/post_controller.dart';
import 'package:m_life_app/controller/user_controller.dart';
import 'package:m_life_app/size.dart';
import 'package:m_life_app/view/pages/post/update_page.dart';

import 'home_page.dart';

class DetailPage extends StatelessWidget {
  final int? id;
  const DetailPage(this.id);

  @override
  Widget build(BuildContext context) {
    // String data = Get.arguments;
    PostController p = Get.find();
    UserController u = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text("$id"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${p.post.value.title}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              Divider(),
              u.principal.value.nickname == p.post.value.authorName
                  ? Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await p.deleteByid(p.post.value.id!);
                            Get.off(() => HomePage());
                          },
                          child: Text("삭제"),
                        ),
                        SizedBox(width: large_gap),
                        ElevatedButton(
                          onPressed: () {
                            Get.off(() => UpdatePage());
                          },
                          child: Text("수정"),
                        ),
                      ],
                    )
                  : SizedBox(),
              Expanded(
                child: SingleChildScrollView(
                  child: Text("${p.post.value.content}"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
