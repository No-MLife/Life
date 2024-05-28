import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:m_life_app/util/jwt.dart';

import '../../util/host.dart';

const RequestURL = "api/v1/category";
const limit = 100;

class PostProvider extends GetConnect {
  // 인기 게시글 조회
  Future<Response> findallpopular() =>
      get("$host/$RequestURL/popular-posts/$limit",
          headers: {"access": jwtToken ?? ""});

  // 모든 게시글 조회(카테고리별 게시판 조회로 바꿔야 함)
  Future<Response> getPostsByCategory(int categoryId) =>
      get("$host/$RequestURL/$categoryId",
          headers: {"access": jwtToken ?? ""});

  // 각각의 게시글 조회
  Future<Response> findByid(int id) => get("$host/$RequestURL/post/$id",
      headers: {"access": jwtToken ?? ""});

  // 게시글 삭제
  Future<Response> deleteByid(int id) => delete("$host/$RequestURL/post/$id",
      headers: {"access": jwtToken ?? ""});

  // 게시글 업데이트
  Future<Response> postUpdate(
      Map data, List<File> images, int categoryId, int id) async {
    var formData = FormData({
      'postRequest': json.encode(data),
    });

    if (images.isNotEmpty) {
      for (var image in images) {
        formData.files.add(MapEntry(
          'images',
          MultipartFile(
            await image.readAsBytes(),
            filename: image.path.split('/').last,
          ),
        ));
      }
    }

    var headers = {
      "access": jwtToken ?? "",
      "Content-Type": "multipart/form-data; boundary=${formData.boundary}",
    };

    return put(
      "$host/$RequestURL/$categoryId/post/$id",
      formData,
      headers: headers,
    );
  }

  Future<Response> postCreate(
      Map data, List<File> images, int categoryId) async {
    var formData = FormData({
      'postRequest': json.encode(data),
    });

    if (images.isNotEmpty) {
      for (var image in images) {
        formData.files.add(MapEntry(
          'images',
          MultipartFile(image, filename: image.path.split('/').last),
        ));
      }
    }

    var headers = {
      "access": jwtToken ?? "",
      "Content-Type": "multipart/form-data; boundary=${formData.boundary}",
    };

    return post(
      "$host/$RequestURL/$categoryId/post",
      formData,
      headers: headers,
    );
  }
}
