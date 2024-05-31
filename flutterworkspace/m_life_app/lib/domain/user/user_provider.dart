import 'package:get/get.dart';
import 'package:m_life_app/view/components/TokenManager.dart';

class UserProvider extends GetConnect with TokenManager {
  Future<Response> signup(Map data) => post("/signup", data);
  Future<Response> logout() => post("/logout", {});
  Future<Response> refresh() => post("/reissue", {});

  Future<Response> login(Map data) => post("/login", data);
  Future<Response> getLike(String nickname) => get(
        "/user_likes/$nickname",
      );

  // 프로필 관련 API
  Future<Response> getProfile(String nickname) => get(
        "/api/v1/users/profile/$nickname",
      );

  Future<Response> updateProfile(String nickname, Map data) => put(
        "/api/v1/users/profile/$nickname",
        data,
      );

  Future<Response> updateProfileImage(
    String nickname,
    FormData formData,
  ) {
    var headers = {
      "Content-Type": "multipart/form-data; boundary=${formData.boundary}",
    };

    return put(
      "/api/v1/users/profile/$nickname/image",
      formData,
      headers: headers,
    );
  }
}
