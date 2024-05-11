import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/post_controller.dart';
import 'package:m_life_app/util/post_category.dart';
import 'package:m_life_app/view/pages/post/wrtie_page.dart';
import '../../../components/ad_banner.dart';
import '../../../components/buildBottomNavigationBar.dart';
import '../../../components/category_emogi.dart';
import '../../../components/custom_header_navi.dart';
import '../../../components/post_item.dart';
import '../detail_page.dart';

class DailyProofPage extends StatelessWidget {
  final Category category;

  DailyProofPage({required this.category});

  final PostController _postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    _postController.getPostsByCategory(category.id);
    final emoji = getCategoryEmoji(category);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'M-life',
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            await _postController.getPostsByCategory(category.id);
          },
          child: ListView.builder(
            itemCount: _postController.posts.length + 3,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  height: 70,
                  margin: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.amber[200],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: AdBanner(
                    imagePaths: [
                      'assets/ad1.png',
                      'assets/ad2.png',
                      'assets/ad3.png',
                      'assets/ad4.png',
                    ],
                  ),
                );
              } else if (index == 1) {
                return Container(
                  padding: EdgeInsets.all(1.0),
                  color: Colors.white,
                  child: Text(
                    '$emoji ${category.name}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                );
              } else if (index == 2) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Divider(
                    color: Colors.grey[400],
                    thickness: 1.0,
                  ),
                );
              }
              final post = _postController.posts[index - 3];

              return Column(
                children: [
                  PostItem(
                    post: post,
                    onTap: () async {
                      await _postController.findByid(post.id!);
                      Get.to(() => DetailPage(post.id));
                    },
                    showCategory: false,
                  ),
                  if (index < _postController.posts.length) Divider(),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => WritePage());
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.amber,
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}
