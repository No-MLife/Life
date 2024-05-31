import 'package:get/get.dart';
import 'package:m_life_app/view/components/token_manager.dart';

class CommentProvider extends GetConnect with TokenManager {
  Future<Response> findAllComment(int postId) => get(
        "/api/v1/post/$postId/comment",
      );

  Future<Response> commentCreate(Map data, int postId) => post(
        "/api/v1/post/$postId/comment",
        data,
      );

  Future<Response> deleteByid(int postId, int commentId) => delete(
        "/api/v1/post/$postId/comment/$commentId",
      );

  Future<Response> commentUpdate(Map data, int postId, int commentId) => put(
        "/api/v1/post/$postId/comment/$commentId",
        data,
      );
  Future<Response> findByid(int postId, commentId) => get(
        "/api/v1/post/$postId/comment/$commentId",
      );
}
