import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

  List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitPost(PostController p) async {
    if (_formKey.currentState!.validate()) {
      // 로딩 스피너 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    strokeWidth: 5.0,
                  ),
                  SizedBox(width: 16),
                  Text("업로드 중..."),
                ],
              ),
            ),
          );
        },
      );

      // 게시글 등록 로직
      await p.postCreate(
        _title.text,
        _content.text,
        _selectedCategory.id,
        _selectedImages,
      );

      // 로딩 스피너 닫기
      Navigator.of(context).pop();

      // 리다이렉트
      switch (_selectedCategory) {
        case Category.free:
          Get.offAll(() => CategoryBoardPage(category: Category.free));
          break;
        case Category.dailyProof:
          Get.offAll(() => CategoryBoardPage(category: Category.dailyProof));
          break;
        case Category.constructionMethod:
          Get.offAll(
              () => CategoryBoardPage(category: Category.constructionMethod));
          break;
        case Category.complaintDiscussion:
          Get.offAll(
              () => CategoryBoardPage(category: Category.complaintDiscussion));
          break;
        case Category.siteDebateDispute:
          Get.offAll(
              () => CategoryBoardPage(category: Category.siteDebateDispute));
          break;
        case Category.equipmentRecommendation:
          Get.offAll(() =>
              CategoryBoardPage(category: Category.equipmentRecommendation));
          break;
        case Category.restaurant:
          Get.offAll(() => CategoryBoardPage(category: Category.restaurant));
          break;
      }
      CustomBottomNavBarController bottomNavBarController =
          Get.put(CustomBottomNavBarController());
      bottomNavBarController.updateColor(1); // 카테고리 탭 인덱스로 설정
    }
  }

  @override
  Widget build(BuildContext context) {
    PostController p = Get.find();
    return Scaffold(
      appBar: CustomAppBar(
        isHome: false,
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
              GestureDetector(
                onTap: _pickImages,
                child: Row(
                  children: [
                    Icon(Icons.photo_library, color: Colors.amber),
                    SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격을 조정
                    Text('사진', style: TextStyle(color: Colors.amber)),
                  ],
                ),
              ),
              SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Image.file(
                        _selectedImages[index],
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.7,
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              CustomElevatedButton(
                text: "글쓰기",
                destination: () => _submitPost(p),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
