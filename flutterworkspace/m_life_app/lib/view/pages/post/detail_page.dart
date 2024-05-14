import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:m_life_app/controller/comment_controller.dart';
import 'package:m_life_app/controller/postLike_controller.dart';
import 'package:m_life_app/controller/post_controller.dart';
import 'package:m_life_app/controller/user_controller.dart';
import 'package:m_life_app/util/formatLikes.dart';
import 'package:m_life_app/util/post_category.dart';
import 'package:m_life_app/view/components/category_board_page.dart';
import 'package:m_life_app/view/components/custom_text_form_field.dart';
import 'package:m_life_app/view/pages/post/update_page.dart';
import '../../components/buildBottomNavigationBar.dart';
import '../../components/confirmation_dialog.dart';
import '../../../util/validator_util.dart';
import '../../components/ad_banner.dart';
import 'home_page.dart';

class DetailPage extends StatelessWidget {
  final int? id;
  final Category? category;
  const DetailPage({required this.id, this.category});

  @override
  Widget build(BuildContext context) {
    PostController p = Get.find();
    UserController u = Get.find();
    PostLikeController pl = Get.put(PostLikeController(this.id!));
    CommentController c = Get.put(CommentController(this.id!));
    final createdPostDateTime =
        DateFormat("yyyy-MM-dd HH:mm").format(p.post.value.created!);

    c.findAllComment(this.id!);
    final _comment = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if(category != null){
              Get.off(() => CategoryBoardPage(category: category!));
            }
            else{
              Get.off(() => HomePage());
            }
          },
          // onPressed: () => Get.off(() => HomePage()),
        ),
        centerTitle: true,
        title: Text("M-Life",
            style: TextStyle(
              fontFamily: 'CustomFont',
              fontSize: 24,
              color: Colors.white,
            )),
        backgroundColor: Colors.amber,
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
                      Get.to(() => UpdatePage());
                    } else if (value == 2) {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          title: "게시글 삭제",
                          content: "게시글을 삭제하시겠습니까?",
                          confirmText: "삭제",
                          onConfirm: () async {
                            // 게시글 삭제 로직
                            p.deleteByid(p.post.value.id!);
                            Get.off(() => HomePage());
                            CustomBottomNavBarController
                                bottomNavBarController =
                                Get.put(CustomBottomNavBarController());
                            bottomNavBarController
                                .updateColor(0); // 인기게시판 탭 인덱스로 설정
                          },
                        ),
                      );
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
                    child: Image.asset(
                      "assets/copy_logo.png",
                      color: Colors.amber,
                    ),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${p.post.value.authorName} ${formatLikes(p.post.value.authorLikes!)}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${createdPostDateTime} ",
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
                    icon: Icon(
                      pl.isLiked.value ? Icons.favorite : Icons.favorite_border,
                      color: pl.isLiked.value ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      pl.isLiked.value ? pl.unlikePost(id!) : pl.likePost(id!);
                    },
                  ),
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
                      Divider(),
                      AdBanner(
                        imagePaths: [
                          'assets/ad1.png',
                          'assets/ad2.png',
                          'assets/ad3.png',
                          'assets/ad4.png',
                        ],
                      ),
                      Divider(),
                      SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: c.comments.length,
                        itemBuilder: (context, index) {
                          final comment = c.comments[index];
                          final createdDateTime = DateFormat("yyyy-MM-dd HH:mm")
                              .format(comment.created!);
                          final isAuthor =
                              u.principal.value.nickname == comment.authorName;
                          final isEditing =
                              c.editingCommentId.value == comment.id;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: Image.asset(
                                  "assets/copy_logo.png",
                                  height: 40,
                                  width: 40,
                                  color: Colors.amber,
                                ),
                                title: isEditing
                                    ? TextField(
                                        controller: c.editingController,
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          hintText: "댓글을 입력하세요",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onSubmitted: (value) {
                                          c.commentUpdate(
                                              value, id!, comment.id!);
                                          c.editingCommentId.value = null;
                                          c.editingController.clear();
                                        },
                                      )
                                    : Text(
                                        "${comment.authorName}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                subtitle: isEditing
                                    ? SizedBox()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${comment.comment}",
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            textAlign: TextAlign.left,
                                            "${createdDateTime}",
                                            maxLines: 2,
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                trailing: isAuthor
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (!isEditing)
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              onPressed: () {
                                                c.editingController.text =
                                                    comment.comment!;
                                                c.editingCommentId.value =
                                                    comment.id;
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                              },
                                            ),
                                          if (isEditing)
                                            IconButton(
                                              icon: Icon(Icons.check),
                                              onPressed: () {
                                                c.commentUpdate(
                                                    c.editingController.text,
                                                    id!,
                                                    comment.id!);
                                                c.editingCommentId.value = null;
                                                c.editingController.clear();
                                              },
                                            ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    ConfirmationDialog(
                                                  title: "댓글 삭제",
                                                  content: "댓글을 삭제하시겠습니까?",
                                                  confirmText: "삭제",
                                                  onConfirm: () {
                                                    // 댓글 삭제 로직
                                                    c.deleteByid(
                                                        this.id!, comment.id!);
                                                    Navigator.of(context).pop();
                                                    Get.off(() =>
                                                        DetailPage(id:this.id));
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    : null,
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (c.editingCommentId.value == null)
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
