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

  Future<int> commentCreate(String content, int postID) async {
    CommentReqDto commentReqDto = CommentReqDto(content);
    Response response =
        await _commentProvider.commentCreate(commentReqDto.toJson(), postID);
    if (response.statusCode == 200) {
      return 1;
    }
    return -1;
  }

//
  // Future<PostResDto> findByid(int id) async {
  //   Response response = await _postProvider.findByid(id);
  //   dynamic body = response.body;
  //   dynamic convertBody = convertUtf8ToObject(body);
  //
  //   PostResDto post = PostResDto();
  //   if (convertBody is Map<String, dynamic>)
  //     post = PostResDto.fromJson(convertBody);
  //   return post;
  // }
  //
  // Future<int> deleteByid(int id) async {
  //   Response response = await _postProvider.deleteByid(id);
  //   if (response.statusCode == 200) {
  //     return 1;
  //   } else {
  //     return -1;
  //   }
  // }
  //
  // Future<int> postUpdate(String title, String content, int id) async {
  //   PostReqDto postReqDto = PostReqDto(title, content);
  //   Response response = await _postProvider.postUpdate(postReqDto.toJson(), id);
  //
  //   if (response.statusCode == 200) {
  //     return 1;
  //   }
  //   return -1;
  // }
  //
}
