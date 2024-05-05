import 'package:get/get_connect/http/src/response/response.dart';
import 'package:m_life_app/domain/postLike/postLike_provider.dart';
import 'package:m_life_app/util/convert_utf8.dart';

// Json -> Dart
class PostLikeRepository {
  final PostLikeProvider _postLikeProvider = PostLikeProvider();

  Future<bool> isLikedByCurrentUser(int postId) async {
    Response response = await _postLikeProvider.isLikedByCurrentUser(postId);
    dynamic body = response.body;
    return body;
  }

  Future<bool> likePost(int postId) async {
    Response response = await _postLikeProvider.likePost(postId);
    if(response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> unlikePost(int postId) async {
    Response response = await _postLikeProvider.unlikePost(postId);
    if(response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
