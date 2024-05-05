import 'package:get/get.dart';
import 'package:m_life_app/util/jwt.dart';
import '../../util/host.dart';

class PostLikeProvider extends GetConnect {
  Future<Response> isLikedByCurrentUser(int postId) =>
      get("$host/api/v1/post/$postId/like/liked",
          headers: {"Authorization": jwtToken ?? ""});

  Future<Response> likePost(int postId) =>
      post("$host/api/v1/post/$postId/like", "",
          headers: {"Authorization": jwtToken ?? ""});

  Future<Response> unlikePost(int postId) =>
      delete("$host/api/v1/post/$postId/like",
          headers: {"Authorization": jwtToken ?? ""});
}
