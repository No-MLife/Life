import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/dto/Res/UserPorfileResDto.dart';
import 'package:m_life_app/domain/user/user_repository.dart';
import 'package:m_life_app/util/jwt.dart';

import '../domain/user/user.dart';

class UserController extends GetxController {
  final UserRepository _userRepository = UserRepository();
  final RxBool isLogin = false.obs; // UI가 관찰 가능한 변수 => 변경이 되며 UI가 자동으로 업데이트
  final principal = User().obs;
  final RxInt totalLike = 0.obs;
  final profile = UserProfileResDto().obs;
  final Rx<ImageProvider> profileImage =
      Rx<ImageProvider>(AssetImage('assets/new_logo_p.png'));
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
  }

  void logout() {
    isLogin.value = false;
    secureStorage.deleteAll(); // 기존 정보 삭제
    jwtToken = null;
  }

  Future<String> login(String username, String password) async {
    String token = await _userRepository.login(username, password);

    if (token != "-1") {
      isLogin.value = true;
      jwtToken = token;
      // jwt을 해독해서 로그인한 유저 정보만 빼오기
      _JwtEncoder(token);
      secureStorage.deleteAll(); // 기존 정보 삭제
      await secureStorage.write(key: 'isLoggedIn', value: 'true');
      await secureStorage.write(key: 'username', value: username);
      await secureStorage.write(key: 'password', value: password);
    } else
      secureStorage.deleteAll(); // 기존 정보 삭제
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
    if (ret != -1) {
      this.totalLike.value = ret;
    } else {
      this.totalLike.value = 0;
    }
  }

  Future<void> getProfile(String nickname) async {
    UserProfileResDto userProfileResDto =
        await _userRepository.getProfile(nickname);
    this.profile.value = userProfileResDto;

    if (userProfileResDto.profileImageUrl != "") {
      try {
        final provider = NetworkImage(userProfileResDto.profileImageUrl!);
        await precacheImage(provider, Get.context!);
        profileImage.value = provider;
      } catch (e) {
        print('Failed to load profile image: $e');
        // 기본 이미지 사용
      }
    } else {
      profileImage.value = AssetImage('assets/new_logo_.png');
    }
  }

  Future<int> updateProfileImage(String nickname, File imageFile) async {
    int result = await _userRepository.updateProfileImage(nickname, imageFile);
    return result;
  }

  Future<int> updateProfile(String nickname, String introduction,
      String jobname, String experience) async {
    int result = await _userRepository.updateProfile(
        nickname, introduction, jobname, experience);
    if (result == -1) {
      print("프로필 업데이트 실패");
      return -1;
    } else {
      print("프로필 업데이트 성공");
      return 1;
    }
  }
}
