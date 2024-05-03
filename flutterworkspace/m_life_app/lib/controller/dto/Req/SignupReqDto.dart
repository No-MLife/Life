class SignupDto {
  final String? username;
  final String? password;
  final String? nickname;

  SignupDto(this.username, this.password, this.nickname);

  Map<String, dynamic> toJson() =>
      {"username": username, "password": password, "nickname": nickname};
}
