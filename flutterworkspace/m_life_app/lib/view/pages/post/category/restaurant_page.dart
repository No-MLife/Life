import 'package:flutter/material.dart';
import 'package:m_life_app/util/post_category.dart';
import '../../../components/category_board_page.dart';

class RestaurantPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategoryBoardPage(category: Category.restaurant);
  }
}