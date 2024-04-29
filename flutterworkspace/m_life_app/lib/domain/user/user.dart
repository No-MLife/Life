import 'package:intl/intl.dart';

class User {
  final int? id;
  final String? nickname;
  final String? username;
  final String? email;
  final DateTime? created;
  final DateTime? updated;

  User(
      {this.id,
      this.username,
      this.nickname,
      this.email,
      this.created,
      this.updated});

  // 통신을 위해서 Json 처럼 생긴 문자열
  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        username = json["username"],
        email = json["email"],
        nickname = json["nickname"],
        created = DateFormat("yyyy-mm-dd").parse(json["created"]),
        updated = DateFormat("yyyy-mm-dd").parse(json["updated"]);
}
