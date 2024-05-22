class PostReqDto {
  final String? title;
  final String? content;
  final List<String>? postImageUrls;

  PostReqDto({
    required this.title,
    required this.content,
    this.postImageUrls,  // 기본값으로 null을 허용하거나, 필요에 따라 기본값을 설정
  });
  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "postImageUrls":postImageUrls ?? [],
      };
}
