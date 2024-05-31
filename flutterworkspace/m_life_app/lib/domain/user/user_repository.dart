import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:m_life_app/controller/dto/Req/LoginReqDto.dart';
import 'package:m_life_app/controller/dto/Req/SignupReqDto.dart';
import 'package:m_life_app/controller/dto/Res/UserPorfileResDto.dart';

import 'package:m_life_app/domain/user/user_provider.dart';
import 'package:m_life_app/util/storeTokens.dart';

import '../../controller/dto/Req/UserProfileReqDto.dart';
import '../../util/convert_utf8.dart';

class UserRepository {
  final UserProvider _userProvider = Get.put(UserProvider());

  Future<String> login(String username, String password) async {
    LoginReqDto loginReqDto = LoginReqDto(username, password);
    Response response = await _userProvider.login(loginReqDto.toJson());
    dynamic headers = response.headers;

    // 헤더가 널이 아니라면 헤더에서 리프레쉬 토큰과 액세스 토큰 가져옴
    if (response.headers == null) return "-1";

    String? refreshToken = headers['set-cookie'];
    String? accessToken = headers['access'];

    if (refreshToken == null || accessToken == null) {
      return "-1";
    }
    await storeTokens(accessToken, refreshToken);
    return accessToken;
  }

  Future<void> logout() async {
    Response response = await _userProvider.logout();
  }

  Future<Map<String, dynamic>?> signup(
      String username, String password, String nickname, String email) async {
    SignupDto signupDto = SignupDto(username, password, nickname, email);
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

  // 프포필 api

  Future<UserProfileResDto> getProfile(String nickname) async {
    Response response = await _userProvider.getProfile(nickname);
    dynamic body = response.body;
    dynamic convertBody = convertUtf8ToObject(body);

    UserProfileResDto profile = UserProfileResDto();
    if (convertBody is Map<String, dynamic>)
      profile = UserProfileResDto.fromJson(convertBody);
    return profile;
  }

  Future<int> updateProfileImage(String nickname, File imageFile) async {
    var multipartFile = MultipartFile(
      imageFile.path,
      filename: "${DateTime.now().millisecondsSinceEpoch}.jpg",
    );
    var formData = FormData({"image": multipartFile});

    Response response =
        await _userProvider.updateProfileImage(nickname, formData);
    if (response.statusCode == 200) {
      return 1;
    } else {
      return -1;
    }
  }

  Future<int> updateProfile(String nickname, String introduction,
      String jobname, String experience) async {
    UserProfileReqDto userProfileReqDto =
        UserProfileReqDto(introduction, jobname, experience);

    Response response =
        await _userProvider.updateProfile(nickname, userProfileReqDto.toJson());

    if (response.statusCode == 200) return 1;
    return -1;
  }
}
