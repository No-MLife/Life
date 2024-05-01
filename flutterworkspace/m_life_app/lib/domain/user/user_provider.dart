import 'package:get/get.dart';

const host = "http://192.168.0.4:8080";
// const host = "http://172.168.1.50:8080";

class UserProvider extends GetConnect {
  Future<Response> signup(Map data) => post("$host/signup", data);
  Future<Response> login(Map data) => post("$host/login", data);
}
