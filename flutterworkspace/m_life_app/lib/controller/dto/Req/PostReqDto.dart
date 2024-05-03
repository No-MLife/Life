class PostReqDto {
  final String? title;
  final String? content;

  PostReqDto(this.title, this.content);
  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
      };
}
