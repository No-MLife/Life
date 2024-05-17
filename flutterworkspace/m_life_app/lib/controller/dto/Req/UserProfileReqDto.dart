class UserProfileReqDto {
  final String? introduction;
  final String? jobName;
  final String? experience;

  UserProfileReqDto(this.introduction, this.jobName, this.experience);
  Map<String, dynamic> toJson() => {
        "introduction": introduction,
        "jobName": jobName,
        "experience": experience,
      };
}
