import 'package:get/get.dart';
import 'package:m_life_app/util/jwt.dart';

const host = "http://192.168.0.102:8080";
// const host = "http://172.168.1.50:8080";

class PostProvider extends GetConnect {
  Future<Response> findall() =>
      get("$host/api/v1/post", headers: {"Authorization": jwtToken ?? ""});

  Future<Response> findByid(int id) =>
      get("$host/api/v1/post/$id", headers: {"Authorization": jwtToken ?? ""});

  Future<Response> deleteByid(int id) => delete("$host/api/v1/post/$id",
      headers: {"Authorization": jwtToken ?? ""});

  Future<Response> postUpdate(Map data, int id) => put(
        "$host/api/v1/post/$id",
        data,
        headers: {"Authorization": jwtToken ?? ""},
      );

  Future<Response> postCreate(Map data) => post(
        "$host/api/v1/post",
        data,
        headers: {"Authorization": jwtToken ?? ""},
      );
}
