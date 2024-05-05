import 'package:get/get.dart';
import 'package:m_life_app/util/jwt.dart';

import '../../util/host.dart';

class CommentProvider extends GetConnect {
  Future<Response> findAllComment(int postId) =>
      get("$host/api/v1/post/$postId/comment",
          headers: {"Authorization": jwtToken ?? ""});

  Future<Response> commentCreate(Map data, int postId) => post(
        "$host/api/v1/post/$postId/comment",
        data,
        headers: {"Authorization": jwtToken ?? ""},
      );

  Future<Response> deleteByid(int postId, int commentId) =>
      delete("$host/api/v1/post/$postId/comment/$commentId",
          headers: {"Authorization": jwtToken ?? ""});

  Future<Response> commentUpdate(Map data, int postId, int commentId) => put(
        "$host/api/v1/post/$postId/comment/$commentId",
        data,
        headers: {"Authorization": jwtToken ?? ""},
      );
  Future<Response> findByid(int postId, commentId) =>
      get("$host/api/v1/post/$postId/comment/$commentId",
          headers: {"Authorization": jwtToken ?? ""});
}
