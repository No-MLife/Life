import 'dart:io';

import 'package:get/get.dart';
import 'package:m_life_app/controller/dto/Res/PostResDto.dart';
import 'package:m_life_app/domain/post/post_repository.dart';

class PostController extends GetxController {
  final PostRepository _postRepository = PostRepository();
  final posts = <PostResDto>[].obs;
  final post = PostResDto().obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> findallpopular() async {
    List<PostResDto> posts = await _postRepository.findallpopular();
    this.posts.value = posts;
  }

  Future<void> getPostsByCategory(int categoryId) async {
    List<PostResDto> posts =
        await _postRepository.getPostsByCategory(categoryId);
    this.posts.value = posts;
  }

  Future<void> findByid(int id) async {
    PostResDto post = await _postRepository.findByid(id);
    this.post.value = post;
  }

  Future<void> deleteByid(int id) async {
    int result = await _postRepository.deleteByid(id);

    if (result == 1) {
      List<PostResDto> reslut =
          posts.value.where((post) => post.id != id).toList();

      posts.value = reslut;
      ;
    }
  }

  Future<void> postUpdate(String title, String content, int categoryId, int id,
      List<File> images, List<String> postImageUrls,) async {
    int result = await _postRepository.postUpdate(
        title, content, categoryId, id, images, postImageUrls);
    if (result == 1) {
      PostResDto post = await _postRepository.findByid(id);
      this.post.value = post;
      this.posts.value = this.posts.map((e) => e.id == id ? post : e).toList();
    }
  }

  Future<void> postCreate(
      String title, String content, int categoryId, List<File> images) async {
    int result =
        await _postRepository.postCreate(title, content, images, categoryId);
    if (result == 1) {
      // 현재 불필요하게 전체 갱신을 하고 있다. 추가적으로 단순히 리스트 뒤에 add 하는 방법을 상객해야함
      // 대표적으로는 스프링부트에서 post를 리턴해주는 방법이 있을듯
      // getPostsByCategory(categoryId);
    }
  }
}
