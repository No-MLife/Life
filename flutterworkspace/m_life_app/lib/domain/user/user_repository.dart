import 'package:get/get_connect/http/src/response/response.dart';
import 'package:m_life_app/controller/dto/Req/LoginReqDto.dart';
import 'package:m_life_app/controller/dto/Req/SignupReqDto.dart';

import 'package:m_life_app/domain/user/user_provider.dart';

class UserRepository {
  final UserProvider _userProvider = UserProvider();

  Future<String> login(String username, String password) async {
    LoginReqDto loginReqDto = LoginReqDto(username, password);
    Response response = await _userProvider.login(loginReqDto.toJson());
    dynamic headers = response.headers;

    if (headers["authorization"] == null) {
      return "-1";
    } else {
      String token = headers["authorization"];
      return token;
    }
  }

  Future<Map<String, dynamic>?> signup(String username, String password, String nickname) async {
    SignupDto signupDto = SignupDto(username, password, nickname);
    Response response = await _userProvider.signup(signupDto.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': response.body,
      };
    }
      return {
        'success': false,
        'message': response.body,
      };
  }

  Future<int> getLike(String nickname) async {
    Response response = await _userProvider.getLike(nickname);
    if (response.statusCode == 200) {
      return response.body;
    }
    return -1;
  }
}
