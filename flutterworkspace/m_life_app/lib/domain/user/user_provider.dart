import 'package:get/get.dart';

import '../../util/host.dart';
import '../../util/jwt.dart';

class UserProvider extends GetConnect {
  Future<Response> signup(Map data) => post("$host/signup", data);
  Future<Response> login(Map data) => post("$host/login", data);
  Future<Response> getLike(String nickname) =>
      get("$host/user_likes/$nickname", headers: {"Authorization": jwtToken ?? ""});
}
