class UserProfileResDto {
  final int? id;
  final String? profileImageUrl;
  final String? introduction;
  final String? jobName;
  final String? experience;

  // final

  UserProfileResDto(
      {this.id,
      this.profileImageUrl,
      this.introduction,
      this.jobName,
      this.experience});

  // 통신을 위해서 Json 처럼 생긴 문자열
  UserProfileResDto.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        profileImageUrl = json["profileImageUrl"] ?? '',
        introduction = json["introduction"] ?? '',
        jobName = json["jobName"],
        experience = json["experience"] ?? '';
}
