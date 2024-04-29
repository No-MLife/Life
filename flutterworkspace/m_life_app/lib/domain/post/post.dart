import 'package:intl/intl.dart';

import '../user/user.dart';

class Post {
  final int? id;
  final String? title;
  final String? content;
  final DateTime? created;
  final DateTime? updated;
  final User? user;

  Post(
      {this.id,
      this.title,
      this.content,
      this.created,
      this.updated,
      this.user});

  // 통신을 위해서 Json 처럼 생긴 문자열
  Post.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        user = User.fromJson(json["user"]),
        content = json["content"],
        created = DateFormat("yyyy-mm-dd").parse(json["created"]),
        updated = DateFormat("yyyy-mm-dd").parse(json["updated"]);
}
