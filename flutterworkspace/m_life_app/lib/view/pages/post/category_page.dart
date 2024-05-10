import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/post_controller.dart';
import 'package:m_life_app/util/post_category.dart';
import 'package:m_life_app/view/pages/post/detail_page.dart';
import '../../components/buildBottomNavigationBar.dart';
import '../../components/buildFloatingActionButton.dart';
import '../../components/post_item.dart';
import '../../components/ad_banner.dart';
import '../../components/custom_header_navi.dart';

class CategoryPage extends StatelessWidget {
  final PostController _postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'M-Life',
      ),
      body: ListView.builder(
        itemCount: Category.values.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              height: 70,
              margin: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.amber[200],
                borderRadius: BorderRadius.circular(45.0),
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
          }

          final categoryIndex = index - 1;
          final category = Category.values[categoryIndex];

          return Obx(
                () {
              final posts = _postController.posts
                  .where((post) => post.categoryId == category.id)
                  .toList();

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        category.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: posts.length > 2 ? 2 : posts.length,
                      itemBuilder: (context, postIndex) {
                        final post = posts[postIndex];
                        return Column(
                          children: [
                            PostItem(
                              post: post,
                              onTap: () async {
                                await _postController.findByid(post.id!);
                                Get.to(() => DetailPage(post.id));
                              },
                            ),
                            if (postIndex < posts.length - 1) SizedBox(height: 8),
                          ],
                        );                      },
                    ),
                    Divider(),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: buildFloatingActionButton(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}