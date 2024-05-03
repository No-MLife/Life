import 'package:intl/intl.dart';

import '../user/user.dart';

class Comment {
  final int? id;
  final String? comment;
  final DateTime? created;
  final DateTime? updated;
  final User? user;
  final int? likecomment;

  Comment(
      {this.id,
      this.comment,
      this.created,
      this.updated,
      this.user,
      this.likecomment});

  // 통신을 위해서 Json 처럼 생긴 문자열
  Comment.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        comment = json["comment"],
        user = User.fromJson(json["user"]),
        created = DateFormat("yyyy-mm-dd").parse(json["created"]),
        updated = DateFormat("yyyy-mm-dd").parse(json["updated"]),
        likecomment = json["likecomment"];
}
