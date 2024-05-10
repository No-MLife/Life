import 'package:get/get.dart';
import 'package:m_life_app/util/jwt.dart';

import '../../util/host.dart';

const RequestURL = "api/v1/category";
const limit = 10;

class PostProvider extends GetConnect {
  // 인기 게시글 조회
  Future<Response> findallpopular() => get("$host/$RequestURL/popular-posts/$limit",
      headers: {"Authorization": jwtToken ?? ""});

  // 모든 게시글 조회(카테고리별 게시판 조회로 바꿔야 함)
  Future<Response> getPostsByCategory(int categoryId) =>
      get("$host/$RequestURL/$categoryId", headers: {"Authorization": jwtToken ?? ""});

  // 각각의 게시글 조회
  Future<Response> findByid(int id) =>
      get("$host/$RequestURL/post/$id", headers: {"Authorization": jwtToken ?? ""});

  // 게시글 삭제
  Future<Response> deleteByid(int id) => delete("$host/$RequestURL/post/$id",
      headers: {"Authorization": jwtToken ?? ""});

  // 게시글 업데이트
  Future<Response> postUpdate(Map data, int categoryId, int id) => put(
        "$host/$RequestURL/$categoryId/post/$id",
        data,
        headers: {"Authorization": jwtToken ?? ""},
      );

  Future<Response> postCreate(Map data, int categoryId) => post(
        "$host/$RequestURL/$categoryId/post",
        data,
        headers: {"Authorization": jwtToken ?? ""},
      );
}
