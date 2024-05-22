import 'dart:io';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:m_life_app/controller/dto/Req/PostReqDto.dart';
import 'package:m_life_app/domain/post/post_provider.dart';
import 'package:m_life_app/util/convert_utf8.dart';

import '../../controller/dto/Res/PostResDto.dart';

// Json -> Dart
class PostRepository {
  final PostProvider _postProvider = PostProvider();

  Future<List<PostResDto>> findallpopular() async {
    Response response = await _postProvider.findallpopular();
    dynamic body = response.body;
    dynamic convertBody = convertUtf8ToObject(body);

    List<PostResDto> posts = [];

    if (convertBody is List) {
      posts = convertBody.map((post) => PostResDto.fromJson(post)).toList();
    }
    return posts;
  }

  Future<List<PostResDto>> getPostsByCategory(int categoryId) async {
    Response response = await _postProvider.getPostsByCategory(categoryId);
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

  Future<int> postUpdate(String title, String content, int categoryId, int id,
      List<File> images) async {
    PostReqDto postReqDto = PostReqDto(title, content);
    Response response = await _postProvider.postUpdate(
        postReqDto.toJson(), images, categoryId, id);

    if (response.statusCode == 200) {
      return 1;
    }
    return -1;
  }

  Future<int> postCreate(
      String title, String content, List<File> images, int categoryId) async {
    PostReqDto postReqDto = PostReqDto(title, content);
    Response response =
        await _postProvider.postCreate(postReqDto.toJson(), images, categoryId);
    if (response.statusCode == 200) {
      return 1;
    }
    return -1;
  }
}
