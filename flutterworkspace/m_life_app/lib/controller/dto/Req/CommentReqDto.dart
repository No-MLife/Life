class CommentReqDto {
  final String? content;

  CommentReqDto(this.content);
  Map<String, dynamic> toJson() => {
        "content": content,
      };
}
