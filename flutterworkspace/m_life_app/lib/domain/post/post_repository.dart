import 'package:get/get_connect/http/src/response/response.dart';
import 'package:m_life_app/controller/dto/Req/PostReqDto.dart';
import 'package:m_life_app/domain/post/post_provider.dart';
import 'package:m_life_app/util/convert_utf8.dart';

import '../../controller/dto/Res/PostResDto.dart';

// Json -> Dart
class PostRepository {
  final PostProvider _postProvider = PostProvider();

  Future<List<PostResDto>> findall() async {
    Response response = await _postProvider.findall();
    dynamic body = response.body;
    dynamic convertBody = convertUtf8ToObject(body);

    List<PostResDto> posts = [];

    if (convertBody is List) {
      posts = convertBody.map((post) => PostResDto.fromJson(post)).toList();
    }
    return posts;
  }

  Future<PostResDto> findByid(int id) async {
    Response response = await _postProvider.findByid(id);
    dynamic body = response.body;
    dynamic convertBody = convertUtf8ToObject(body);

    PostResDto post = PostResDto();
    if (convertBody is Map<String, dynamic>)
      post = PostResDto.fromJson(convertBody);
    return post;
  }

  Future<int> deleteByid(int id) async {
    Response response = await _postProvider.deleteByid(id);
    if (response.statusCode == 200) {
      return 1;
    } else {
      return -1;
    }
  }

  Future<int> postUpdate(String title, String content, int id) async {
    PostReqDto postReqDto = PostReqDto(title, content);
    Response response = await _postProvider.postUpdate(postReqDto.toJson(), id);

    if (response.statusCode == 200) {
      return 1;
    }
    return -1;
  }

  Future<int> postCreate(String title, String content) async {
    PostReqDto postReqDto = PostReqDto(title, content);
    Response response = await _postProvider.postCreate(postReqDto.toJson());
    if (response.statusCode == 200) {
      return 1;
    }
    return -1;
  }
}
