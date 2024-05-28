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
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Margin 조정
      padding: EdgeInsets.all(8), // Padding 조정
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Border radius 조정
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
                  Container(
                    height: 40, // Height 조정
                    width: 40, // Width 조정
                    child: post.postImageUrls!.isEmpty
                        ? Image.asset(
                            "assets/copy_logo.png",
                            color: Colors.amber,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            post.postImageUrls![0],
                            fit: BoxFit.cover,
                          ),
                  ),
                  SizedBox(height: 4), // Spacing 조정
                  Container(
                    width: 70, // Width 조정
                    child: Text(
                      "${post.authorName} ${formatLikes(post.authorLikes!)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10, // Font size 조정
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10), // Width 조정
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
                        fontSize: 12, // Font size 조정
                        color: Colors.blueAccent,
                      ),
                    ),
                  Text(
                    "${post.title}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12, // Font size 조정
                    ),
                  ),
                  SizedBox(height: 2), // Spacing 조정
                  if (!showCategory)
                    Container(
                      width: double.infinity,
                      child: Text(
                        "${post.content}",
                        style: TextStyle(
                          fontSize: 12, // Font size 조정
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  SizedBox(height: 4), // Spacing 조정
                  Row(
                    children: [
                      Icon(
                        Icons.comment,
                        size: 14, // Icon size 조정
                        color: Colors.grey,
                      ),
                      SizedBox(width: 2), // Spacing 조정
                      Text(
                        "${post.commentList!.length}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10, // Font size 조정
                        ),
                      ),
                      SizedBox(width: 8), // Spacing 조정
                      Icon(
                        Icons.favorite,
                        size: 14, // Icon size 조정
                        color: Colors.red,
                      ),
                      SizedBox(width: 2), // Spacing 조정
                      Text(
                        "${post.likeCount}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10, // Font size 조정
                        ),
                      ),
                      SizedBox(width: 4), // Spacing 조정
                      if (post.postImageUrls!.isNotEmpty)
                        Icon(Icons.image_outlined, size: 14), // Icon size 조정
                      SizedBox(width: 2), // Spacing 조정
                      if (post.postImageUrls!.isNotEmpty)
                        Text(
                          "${post.postImageUrls!.length}",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10, // Font size 조정
                          ),
                        ),
                      Spacer(),
                      Icon(
                        Icons.access_time,
                        size: 14, // Icon size 조정
                        color: Colors.grey,
                      ),
                      SizedBox(width: 2), // Spacing 조정
                      Text(
                        formatDateTime(post.created!),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10, // Font size 조정
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
