import 'package:get/get.dart';
import 'package:m_life_app/domain/postLike/postLike_repository.dart';

class PostLikeController extends GetxController {
  final PostLikeRepository _postLikeRepository = Get.put(PostLikeRepository());

  final RxBool isLiked = false.obs; // UI가 관찰 가능한 변수 => 변경이 되며 UI가 자동으로 업데이트
  final int postId;

  PostLikeController(this.postId);

  @override
  void onInit() {
    super.onInit();
    isLikedByCurrentUser(postId);
  }

  Future<void> isLikedByCurrentUser(int postId) async {
    bool isLiked = await _postLikeRepository.isLikedByCurrentUser(postId);
    this.isLiked.value = isLiked;
  }

  Future<void> likePost(int postId) async {
    bool isLiked = await _postLikeRepository.likePost(postId);
    if (isLiked == true) {
      this.isLiked.value = true;
    }
  }

  Future<void> unlikePost(int postId) async {
    bool isLiked = await _postLikeRepository.unlikePost(postId);
    if (isLiked == true) {
      this.isLiked.value = false;
    }
  }
}
