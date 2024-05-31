import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:m_life_app/domain/postLike/postLike_provider.dart';
import 'package:m_life_app/util/convert_utf8.dart';

// Json -> Dart
class PostLikeRepository {
  final PostLikeProvider _postLikeProvider = Get.put(PostLikeProvider());

  Future<bool> isLikedByCurrentUser(int postId) async {
    try {
      Response response = await _postLikeProvider.isLikedByCurrentUser(postId);
      dynamic body = response.body;
      // null이 반환될 경우 false 반환
      if (body == null) {
        return false;
      }
      // body가 bool 타입이 아닐 경우 처리
      if (body is bool) {
        return body;
      } else {
        throw Exception("Unexpected response type: ${body.runtimeType}");
      }
    } catch (e) {
      // 예외 처리
      print("Error in isLikedByCurrentUser: $e");
      return false;
    }
  }

  Future<bool> likePost(int postId) async {
    Response response = await _postLikeProvider.likePost(postId);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> unlikePost(int postId) async {
    Response response = await _postLikeProvider.unlikePost(postId);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
