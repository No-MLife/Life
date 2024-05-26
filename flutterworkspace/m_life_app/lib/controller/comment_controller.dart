import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/dto/Res/CommentResDto.dart';
import 'package:m_life_app/domain/comment/comment_repository.dart';

class CommentController extends GetxController {
  final CommentRepository _commentRepository = CommentRepository();
  final comments = <CommentResDto>[].obs;
  final comment = CommentResDto().obs;
  final int postId;

  final editingCommentId = Rxn<int>();
  final editingController = TextEditingController();

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
    CommentResDto? comment =
        await _commentRepository.commentCreate(content, postId);
    if (comment != null) {
      comments.add(comment);
    }
  }

  Future<void> deleteByid(int postId, int commentId) async {
    int result = await _commentRepository.deleteByid(postId, commentId);

    if (result == 1) {
      List<CommentResDto> reslut =
          comments.value.where((comment) => comment.id != commentId).toList();
      comments.value = reslut;
    }
  }

  Future<void> commentUpdate(String content, int postId, int commentId) async {
    int result =
        await _commentRepository.commentUpdate(content, postId, commentId);
    if (result == 1) {
      CommentResDto comment =
          await _commentRepository.findByid(postId, commentId);
      this.comment.value = comment;
      comments.value =
          comments.map((e) => e.id == commentId ? comment : e).toList();
    }
  }

  Future<void> findByid(int postId, int commentId) async {
    CommentResDto comment =
        await _commentRepository.findByid(postId, commentId);
    this.comment.value = comment;
  }
}
