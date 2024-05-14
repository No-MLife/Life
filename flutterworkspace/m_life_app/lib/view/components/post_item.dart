import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/dto/Res/PostResDto.dart';
import 'package:m_life_app/controller/user_controller.dart';

class PostItem extends StatelessWidget {
  final PostResDto post;
  final VoidCallback onTap;
  final bool showCategory;

  const PostItem({
    Key? key,
    required this.post,
    required this.onTap,
    this.showCategory = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController _userController = Get.find();
    
    return Container(
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
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/copy_logo.png",
                    color: Colors.amber,
                    height: 45,
                    width: 45,
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 80,
                    child: Text(
                      "${post.authorName}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16,),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showCategory)
                    Text(
                      "[${post.boardName}]",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.blueAccent,
                      ),
                    ),
                  Text(
                    "${post.title}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  if (!showCategory)
                    Container(
                      width: double.infinity,
                      child: Text(
                        "${post.content}",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(

                        "댓글 ${post.commentList!.length}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "좋아요 ${post.likeCount}",
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
    );
  }
}