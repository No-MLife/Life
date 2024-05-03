import 'package:get/get.dart';
import 'package:m_life_app/util/jwt.dart';

// const host = "http://192.168.0.9:8080";
// const host = "http://172.168.1.50:8080";
const host = "http://172.19.32.1:8080"; // home

class PostLikeProvider extends GetConnect {
  Future<Response> isLikedByCurrentUser(int postId) =>
      get("$host/api/v1/post/$postId/like/liked", headers: {"Authorization": jwtToken ?? ""});

  Future<Response> likePost(int postId) =>
      post("$host/api/v1/post/$postId/like","", headers: {"Authorization": jwtToken ?? ""});

  Future<Response> unlikePost(int postId) =>
      delete("$host/api/v1/post/$postId/like", headers: {"Authorization": jwtToken ?? ""});
}
