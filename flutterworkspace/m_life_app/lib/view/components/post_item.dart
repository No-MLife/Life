import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/dto/Res/PostResDto.dart';
import 'package:m_life_app/controller/user_controller.dart';

import '../../util/formatLikes.dart';
import '../../util/format_date_time.dart';

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
                  post.postImageUrls!.length == 0
                      ? Image.asset(
                          "assets/copy_logo.png",
                          color: Colors.amber,
                          height: 45,
                          width: 45,
                        )
                      : Image.network(post.postImageUrls![0]),
                  SizedBox(height: 8),
                  Container(
                    width: 80,
                    child: Text(
                      "${post.authorName} ${formatLikes(post.authorLikes!)}",
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
            SizedBox(
              width: 16,
            ),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.comment,
                        size: 16,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "${post.commentList!.length}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(
                        Icons.favorite,
                        size: 16,
                        color: Colors.red,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "${post.likeCount}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 6),
                      if (post.postImageUrls!.length != 0)
                        Icon(Icons.image_outlined),
                      SizedBox(width: 4),
                      if (post.postImageUrls!.length != 0)
                        Text(
                          "${post.postImageUrls!.length}",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      Spacer(),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4),
                      Text(
                        formatDateTime(post.created!),
                        style: TextStyle(
                          color: Colors.grey,
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
