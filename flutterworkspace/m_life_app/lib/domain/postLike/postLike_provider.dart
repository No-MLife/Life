import 'package:get/get.dart';
import 'package:m_life_app/util/jwt.dart';
import 'package:m_life_app/view/components/token_manager.dart';
import '../../util/host.dart';

class PostLikeProvider extends GetConnect with TokenManager {
  Future<Response> isLikedByCurrentUser(int postId) => get(
        "/api/v1/post/$postId/like/liked",
      );

  Future<Response> likePost(int postId) => post(
        "/api/v1/post/$postId/like",
        "",
      );

  Future<Response> unlikePost(int postId) => delete(
        "/api/v1/post/$postId/like",
      );
}
