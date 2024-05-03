import 'package:get/get.dart';
import 'package:m_life_app/util/jwt.dart';

// const host = "http://192.168.0.9:8080";
// const host = "http://172.168.1.50:8080";

const host = "http://172.19.32.1:8080"; // home

class CommentProvider extends GetConnect {
  Future<Response> findAllComment(int postId) =>
      get("$host/api/v1/post/$postId/comment",
          headers: {"Authorization": jwtToken ?? ""});

  Future<Response> commentCreate(Map data, int postId) => post(
        "$host/api/v1/post/$postId/comment",
        data,
        headers: {"Authorization": jwtToken ?? ""},
      );

  //
  // Future<Response> findByid(int id) =>
  //     get("$host/api/v1/post/$id", headers: {"Authorization": jwtToken ?? ""});
  //
  // Future<Response> deleteByid(int id) => delete("$host/api/v1/post/$id",
  //     headers: {"Authorization": jwtToken ?? ""});
  //
  // Future<Response> postUpdate(Map data, int id) => put(
  //   "$host/api/v1/post/$id",
  //   data,
  //   headers: {"Authorization": jwtToken ?? ""},
  // );
  //
}
