import 'package:get/get.dart';
import 'package:m_life_app/controller/dto/Res/CommentResDto.dart';
import 'package:m_life_app/domain/comment/comment_repository.dart';

class CommentController extends GetxController {
  final CommentRepository _commentRepository = CommentRepository();
  final comments = <CommentResDto>[].obs;
  final comment = CommentResDto().obs;
  final int postId;

  CommentController(this.postId);

  @override
  void onInit() {
    super.onInit();
    findAllComment(postId);
  }

  Future<void> findAllComment(int postId) async {
    List<CommentResDto> comments =
        await _commentRepository.findAllComment(postId);
    this.comments.value = comments;
  }

  Future<void> commentCreate(String content, int postId) async {
    int result = await _commentRepository.commentCreate(content, postId);
    if (result == 1) {
      findAllComment(postId);
    }
  }

  // Future<void> findByid(int id) async {
  //   PostResDto post = await _postRepository.findByid(id);
  //   this.post.value = post;
  // }
  //
  // Future<void> deleteByid(int id) async {
  //   int result = await _postRepository.deleteByid(id);
  //
  //   if (result == 1) {
  //     List<PostResDto> reslut =
  //         posts.value.where((post) => post.id != id).toList();
  //
  //     posts.value = reslut;
  //     ;
  //   }
  // }
  //
  // Future<void> postUpdate(String title, String content, int id) async {
  //   int result = await _postRepository.postUpdate(title, content, id);
  //   if (result == 1) {
  //     PostResDto post = await _postRepository.findByid(id);
  //     this.post.value = post;
  //     this.posts.value = this.posts.map((e) => e.id == id ? post : e).toList();
  //   }
  // }
  //
}
