import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/post_controller.dart';
import 'package:m_life_app/util/validator_util.dart';
import '../../../util/post_category.dart';
import '../../components/buildBottomNavigationBar.dart';
import '../../components/category_board_page.dart';
import '../../components/confirmation_dialog.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_header_navi.dart';
import '../../components/custom_text_area.dart';
import '../../components/custom_text_form_field.dart';


class WritePage extends StatefulWidget {
  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();
  Category _selectedCategory = Category.free; // 초기 선택된 카테고리

  @override
  Widget build(BuildContext context) {
    PostController p = Get.find();
    return Scaffold(
      appBar: CustomAppBar(
        title: 'M-Life',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                DropdownButtonFormField<Category>(
                  value: _selectedCategory,
                  onChanged: (Category? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  items: Category.values.map((Category category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: '게시판',
                  ),
                ),
                CustomTextFormField(
                  controller: _title,
                  text: "제목",
                  funValidator: validate_title(),
                ),
                CustomTextFormArea(
                  controller: _content,
                  text: "내용",
                  funValidator: validate_content(),
                ),
                CustomElevatedButton(
                  text: "글쓰기",
                  destination: () async {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            ConfirmationDialog(
                              title: "게시글 등록",
                              content: "게시글을 등록하시겠습니까?",
                              confirmText: "등록",
                              onConfirm: () async {
                                // 게시글 등록 로직
                                await p.postCreate(_title.text, _content.text, _selectedCategory.id);
                                switch (_selectedCategory) {
                                  case Category.free:
                                    Get.offAll(() => CategoryBoardPage(category: Category.free));
                                    break;
                                  case Category.dailyProof:
                                    Get.offAll(() => CategoryBoardPage(category: Category.dailyProof));
                                    break;
                                  case Category.constructionMethod:
                                    Get.offAll(() => CategoryBoardPage(category: Category.constructionMethod));
                                    break;
                                  case Category.graduationReview:
                                    Get.offAll(() => CategoryBoardPage(category: Category.graduationReview));
                                    break;
                                  case Category.complaintDiscussion:
                                    Get.offAll(() => CategoryBoardPage(category: Category.complaintDiscussion));
                                    break;
                                  case Category.siteDebateDispute:
                                    Get.offAll(() => CategoryBoardPage(category: Category.siteDebateDispute));
                                    break;
                                  case Category.unionRelated:
                                    Get.offAll(() => CategoryBoardPage(category: Category.unionRelated));
                                    break;
                                  case Category.equipmentRecommendation:
                                    Get.offAll(() => CategoryBoardPage(category: Category.equipmentRecommendation));
                                    break;
                                  case Category.restaurant:
                                    Get.offAll(() => CategoryBoardPage(category: Category.restaurant));
                                    break;
                                }
                                CustomBottomNavBarController bottomNavBarController = Get.put(CustomBottomNavBarController());
                                bottomNavBarController.updateColor(1); // 카테고리 탭 인덱스로 설정
                              },
                            ),
                      );
                    }
                  },
                )              ],
            )),
      ),
    );
  }
}