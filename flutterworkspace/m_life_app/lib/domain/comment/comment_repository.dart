import 'package:get/get_connect/http/src/response/response.dart';
import 'package:m_life_app/controller/dto/Req/CommentReqDto.dart';
import 'package:m_life_app/controller/dto/Res/CommentResDto.dart';
import 'package:m_life_app/domain/comment/comment_provider.dart';
import 'package:m_life_app/util/convert_utf8.dart';

// Json -> Dart
class CommentRepository {
  final CommentProvider _commentProvider = CommentProvider();

  Future<List<CommentResDto>> findAllComment(int postId) async {
    Response response = await _commentProvider.findAllComment(postId);
    dynamic body = response.body;
    dynamic convertBody = convertUtf8ToObject(body);

    List<CommentResDto> comments = [];

    if (convertBody is List) {
      comments = convertBody
          .map((comment) => CommentResDto.fromJson(comment))
          .toList();
    }
    return comments;
  }

  Future<CommentResDto?> commentCreate(String content, int postID) async {
    CommentReqDto commentReqDto = CommentReqDto(content);
    Response response =
        await _commentProvider.commentCreate(commentReqDto.toJson(), postID);

    CommentResDto commentResDto;
    if (response.statusCode == 200) {
      dynamic body = response.body;
      dynamic convertBody = convertUtf8ToObject(body);
      commentResDto = CommentResDto.fromJson(convertBody);
      return commentResDto;
    }
    return null;
  }

  Future<int> deleteByid(int postId, int commentId) async {
    Response response = await _commentProvider.deleteByid(postId, commentId);
    if (response.statusCode == 200) {
      return 1;
    } else {
      return -1;
    }
  }

  Future<int> commentUpdate(String content, int postID, int commentId) async {
    CommentReqDto commentReqDto = CommentReqDto(content);
    Response response = await _commentProvider.commentUpdate(
        commentReqDto.toJson(), postID, commentId);
    if (response.statusCode == 200) {
      return 1;
    }
    return -1;
  }

  Future<CommentResDto> findByid(int postId, int commentId) async {
    Response response = await _commentProvider.findByid(postId, commentId);
    dynamic body = response.body;
    dynamic convertBody = convertUtf8ToObject(body);

    CommentResDto comment = CommentResDto();
    if (convertBody is Map<String, dynamic>)
      comment = CommentResDto.fromJson(convertBody);
    return comment;
  }
}
