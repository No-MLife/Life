import 'dart:io';
import 'package:get/get.dart';
import 'package:m_life_app/controller/dto/Res/PostResDto.dart';
import 'package:m_life_app/domain/post/post_repository.dart';

class PostController extends GetxController {
  final PostRepository _postRepository = PostRepository();
  final popularPosts = <PostResDto>[].obs;
  final categoryPosts = <int, List<PostResDto>>{}.obs;
  final post = PostResDto().obs;
  final isLoading = false.obs;
  final isDetailLoading = false.obs; // 추가된 상태 관리

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> findallpopular() async {
    isLoading.value = true;
    List<PostResDto> posts = await _postRepository.findallpopular();
    this.popularPosts.value = posts;
    isLoading.value = false;
  }

  Future<void> getPostsByCategory(int categoryId) async {
    isLoading.value = true;
    List<PostResDto> posts = await _postRepository.getPostsByCategory(categoryId);
    this.categoryPosts[categoryId] = posts;
    isLoading.value = false;
  }

  Future<PostResDto?> findByid(int id) async {
    isDetailLoading.value = true;
    try {
      PostResDto post = await _postRepository.findByid(id);
      this.post.value = post;
      return post;
    } finally {
      isDetailLoading.value = false;
    }
  }

  Future<void> deleteByid(int id) async {
    isLoading.value = true;
    int result = await _postRepository.deleteByid(id);

    if (result == 1) {
      for (int categoryId in categoryPosts.keys) {
        categoryPosts[categoryId] = categoryPosts[categoryId]!
            .where((post) => post.id != id)
            .toList();
      }
    }
    isLoading.value = false;
  }

  Future<void> postUpdate(
      String title,
      String content,
      int categoryId,
      int id,
      List<File> images,
      List<String> postImageUrls,
      ) async {
    isLoading.value = true;
    int result = await _postRepository.postUpdate(
        title, content, categoryId, id, images, postImageUrls);
    if (result == 1) {
      PostResDto post = await _postRepository.findByid(id);
      this.post.value = post;
      this.categoryPosts[categoryId] = this.categoryPosts[categoryId]!
          .map((e) => e.id == id ? post : e)
          .toList();
    }
    isLoading.value = false;
  }

  Future<void> postCreate(
      String title, String content, int categoryId, List<File> images) async {
    isLoading.value = true;
    await _postRepository.postCreate(title, content, images, categoryId);
    isLoading.value = false;
  }
}
