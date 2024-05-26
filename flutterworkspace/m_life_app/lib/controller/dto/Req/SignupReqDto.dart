class SignupDto {
  final String? username;
  final String? password;
  final String? nickname;
  final String? email;
  SignupDto(this.username, this.password, this.nickname, this.email);

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "nickname": nickname,
        "email": email
      };
}
