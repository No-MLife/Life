import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/post_controller.dart';
import 'package:m_life_app/util/post_category.dart';
import 'package:m_life_app/view/components/post_item.dart';
import 'package:m_life_app/view/pages/post/category_page.dart';
import 'package:m_life_app/view/pages/post/wrtie_page.dart';
import '../pages/post/detail_page.dart';
import 'ad_banner.dart';
import 'buildBottomNavigationBar.dart';
import 'buildFloatingActionButton.dart';
import 'category_emogi.dart';
import 'custom_header_navi.dart';

class CategoryBoardPage extends StatefulWidget {
  final Category category;

  CategoryBoardPage({required this.category});

  @override
  _CategoryBoardPageState createState() => _CategoryBoardPageState();
}

class _CategoryBoardPageState extends State<CategoryBoardPage> {
  final PostController _postController = Get.put(PostController());

  @override
  void initState() {
    super.initState();
    _postController
        .getPostsByCategory(widget.category.id); // 페이지 초기화 시 해당 카테고리의 글 가져오기
  }

  @override
  Widget build(BuildContext context) {
    final emoji = getCategoryEmoji(widget.category);

    return Scaffold(
      appBar: CustomAppBar(
          isHome: false,
          title: 'M-life',
          onBackPressed: () => Get.off(() => CategoryPage())),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            await _postController.getPostsByCategory(widget.category.id);
          },
          child: ListView.builder(
            itemCount: _postController.posts.length + 3,
            itemBuilder: (context, index) => _buildListItem(index, emoji),
          ),
        ),
      ),
      floatingActionButton: buildFloatingActionButton(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget _buildListItem(int index, String emoji) {
    if (index == 0) {
      return _buildAdBanner();
    } else if (index == 1) {
      return _buildCategoryTitle(emoji);
    } else if (index == 2) {
      return _buildDivider();
    }

    final reversedIndex = _postController.posts.length - 1 - (index - 3);
    final post = _postController.posts[reversedIndex];

    return Column(
      children: [
        PostItem(
          post: post,
          onTap: () async {
            await _postController.findByid(post.id!);
            final result = await Get.to(
                () => DetailPage(category: widget.category, id: post.id));
            if (result != null && result) {
              _postController.getPostsByCategory(widget.category.id);
            }
          },
          showCategory: false,
        ),
        if (index < _postController.posts.length + 2) _buildDivider(),
      ],
    );
  }

  Widget _buildAdBanner() {
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
  }

  Widget _buildCategoryTitle(String emoji) {
    return Container(
      padding: EdgeInsets.all(1.0),
      color: Colors.white,
      child: Text(
        '$emoji ${widget.category.name}',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Divider(
        color: Colors.grey[400],
        thickness: 1.0,
      ),
    );
  }
}
