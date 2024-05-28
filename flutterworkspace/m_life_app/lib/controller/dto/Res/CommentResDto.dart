import 'package:intl/intl.dart';

class CommentResDto {
  final int? id;
  final String? comment;
  final DateTime? created;
  final int? likeCount;
  final String? authorName;

  CommentResDto(
      {this.id, this.comment, this.created, this.likeCount, this.authorName});

  // 통신을 위해서 Json 처럼 생긴 문자열
  CommentResDto.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        comment = json["content"] ?? '',
        created = DateFormat("yyyy-MM-ddTHH:mm").parse(json["createAt"]),
        likeCount = json["likeCount"],
        authorName = json["commentAuthor"] ?? '';
}
