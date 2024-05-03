import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/comment_controller.dart';
import 'package:m_life_app/controller/post_controller.dart';
import 'package:m_life_app/controller/user_controller.dart';
import 'package:m_life_app/view/components/custom_text_form_field.dart';
import 'package:m_life_app/view/pages/post/update_page.dart';

import '../../../util/validator_util.dart';
import 'home_page.dart';

class DetailPage extends StatelessWidget {
  final int? id;
  const DetailPage(this.id);

  @override
  Widget build(BuildContext context) {
    PostController p = Get.find();
    UserController u = Get.find();
    CommentController c = Get.put(CommentController(this.id!));

    final _comment = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text("M-Life"),
        actions: [
          u.principal.value.nickname == p.post.value.authorName
              ? PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("수정"),
                      value: 1,
                    ),
                    PopupMenuItem(
                      child: Text("삭제"),
                      value: 2,
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 1) {
                      Get.off(() => UpdatePage());
                    } else if (value == 2) {
                      p.deleteByid(p.post.value.id!);
                      Get.off(() => HomePage());
                    }
                  },
                )
              : SizedBox(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    child: Image.asset("assets/logo.png"),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${p.post.value.authorName} + 유저의 좋아요 개수 + ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${p.post.value.created} ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Row(
                        children: [
                          Text(
                            "댓글 : ${p.post.value.commentList!.length} ",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            "좋아요 : ${p.post.value.likeCount} ",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    "${p.post.value.title}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                    // 좋아요 기능 추가해야함
                    icon: Icon(
                      p.post.value.authorName != u.principal.value.nickname
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: p.post.value.likeCount != null
                          ? Colors.red
                          : Colors.grey,
                    ),
                    onPressed: () {
                      print("Hello world");
                      p.post.value.likeCount!;
                    },
                  )
                ],
              ),
              Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("${p.post.value.content}",
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 16),
                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.amber[200],
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        child: Center(
                          child: Text(
                            '광고 영역',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: c.comments.length,
                        itemBuilder: (context, index) {
                          final comment = c.comments[index];
                          print(comment.authorName);
                          return ListTile(
                            leading: Image.asset("assets/logo.png"),
                            title: Text(
                              "${comment.authorName}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${comment.comment}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    // TextField
                    child: CustomTextFormField(
                      controller: _comment,
                      text: "",
                      funValidator: validate_comment(),
                    ),
                  ),
                  SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      c.commentCreate(_comment.text, p.post.value.id!);
                      _comment.clear();
                      FocusScope.of(context).unfocus();
                    },
                    child: Text("등록"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
