import 'dart:convert';

import 'package:get/get.dart';
import 'package:m_life_app/domain/user/user_repository.dart';
import 'package:m_life_app/util/jwt.dart';

import '../domain/user/user.dart';

class UserController extends GetxController {
  final UserRepository _userRepository = UserRepository();
  final RxBool isLogin = false.obs; // UI가 관찰 가능한 변수 => 변경이 되며 UI가 자동으로 업데이트
  final principal = User().obs;
  final RxInt totalLike = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }


  void logout() {
    isLogin.value = false;
    jwtToken = null;
  }

  Future<String> login(String username, String password) async {
    String token = await _userRepository.login(username, password);

    if (token != "-1") {
      isLogin.value = true;
      jwtToken = token;
      // jwt을 해독해서 로그인한 유저 정보만 빼오기
      _JwtEncoder(token);
    }
    return token;
  }

  void _JwtEncoder(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    final decodedPayload = jsonDecode(decoded);
    this.principal.value = User(nickname: decodedPayload["nickname"]);
  }


  Future<void> getLike(String nickname) async {
    int ret = await _userRepository.getLike(nickname);
    if(ret != -1){
      this.totalLike.value = ret;
    }
    else{
      this.totalLike.value = 0;
    }

  }
}
