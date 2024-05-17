import 'dart:io';

import 'package:get/get.dart';
import 'package:m_life_app/controller/dto/Res/UserPorfileResDto.dart';
import '../../controller/dto/Req/UserProfileReqDto.dart';
import '../../util/host.dart';
import '../../util/jwt.dart';

class UserProvider extends GetConnect {
  Future<Response> signup(Map data) => post("$host/signup", data);
  Future<Response> login(Map data) => post("$host/login", data);
  Future<Response> getLike(String nickname) => get("$host/user_likes/$nickname",
      headers: {"Authorization": jwtToken ?? ""});

  // 프로필 관련 API
  Future<Response> getProfile(String nickname) =>
      get("$host/api/v1/users/profile/$nickname",
          headers: {"Authorization": jwtToken ?? ""});

  Future<Response> updateProfile(String nickname, Map data) =>
      put("$host/api/v1/users/profile/$nickname", data,
          headers: {"Authorization": jwtToken ?? ""});

  Future<Response> updateProfileImage(
    String nickname,
    FormData formData,
  ) {
    var headers = {
      "Authorization": jwtToken ?? "",
      "Content-Type": "multipart/form-data; boundary=${formData.boundary}",
    };

    return put(
      "$host/api/v1/users/profile/$nickname/image",
      formData,
      headers: headers,
    );
  }
}
