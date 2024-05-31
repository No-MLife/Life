import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:m_life_app/view/components/token_manager.dart';

const RequestURL = "api/v1/category";
const limit = 100;

class PostProvider extends GetConnect with TokenManager {
  // 인기 게시글 조회
  Future<Response> findallpopular() => get(
        "/$RequestURL/popular-posts/$limit",
      );

  // 모든 게시글 조회(카테고리별 게시판 조회로 바꿔야 함)
  Future<Response> getPostsByCategory(int categoryId) => get(
        "/$RequestURL/$categoryId",
      );

  // 각각의 게시글 조회
  Future<Response> findByid(int id) => get(
        "/$RequestURL/post/$id",
      );

  // 게시글 삭제
  Future<Response> deleteByid(int id) => delete(
        "/$RequestURL/post/$id",
      );

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
      "Content-Type": "multipart/form-data; boundary=${formData.boundary}",
    };

    return put(
      "/$RequestURL/$categoryId/post/$id",
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
      "Content-Type": "multipart/form-data; boundary=${formData.boundary}",
    };

    return post(
      "/$RequestURL/$categoryId/post",
      formData,
      headers: headers,
    );
  }
}
