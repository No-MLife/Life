import 'package:get/get.dart';

import '../../util/jwt.dart';

// const host = "http://192.168.0.9:8080";
// const host = "http://172.168.1.50:8080";

const host = "http://172.19.32.1:8080"; // home

class UserProvider extends GetConnect {
  Future<Response> signup(Map data) => post("$host/signup", data);
  Future<Response> login(Map data) => post("$host/login", data);
  Future<Response> getLike() => get("$host/like", headers: {"Authorization": jwtToken ?? ""});
}
