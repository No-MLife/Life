import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m_life_app/controller/post_controller.dart';
import 'package:m_life_app/util/validator_util.dart';
import 'package:m_life_app/view/pages/post/detail_page.dart';
import '../../../util/post_category.dart';
import '../../components/confirmation_dialog.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_header_navi.dart';
import '../../components/custom_text_area.dart';
import '../../components/custom_text_form_field.dart';

class UpdatePage extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();
  Category _selectedCategory = Category.free;

  List<File> _selectedImages = [];
  List<String> _postImageUrls = [];

  @override
  void initState() {
    super.initState();
    final PostController p = Get.find();
    _title.text = "${p.post.value.title}";
    _content.text = "${p.post.value.content}";
    _selectedCategory = Category.values
        .firstWhere((category) => category.id == p.post.value.categoryId);
    _postImageUrls = (p.post.value.postImageUrls ?? [])
        .map((url) => url.toString())
        .toList();
  }

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
      if (index < _postImageUrls.length) {
        _postImageUrls.removeAt(index);
      } else {
        int fileIndex = index - _postImageUrls.length;
        _selectedImages.removeAt(fileIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final PostController p = Get.find();

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
                text: "Title",
                funValidator: validate_title(),
              ),
              CustomTextFormArea(
                controller: _content,
                text: "Content",
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
              )
,
              SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _selectedImages.length + _postImageUrls.length,
                itemBuilder: (context, index) {
                  if (index < _postImageUrls.length) {
                    return Stack(
                      children: [
                        Image.network(
                          _postImageUrls[index],
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
                  } else {
                    int fileIndex = index - _postImageUrls.length;
                    return Stack(
                      children: [
                        Image.file(
                          _selectedImages[fileIndex],
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
                  }
                },
              ),
              CustomElevatedButton(
                text: "글 수정하기",
                destination: () async {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        title: "게시글 수정",
                        content: "게시글을 수정하시겠습니까?",
                        confirmText: "수정",
                        onConfirm: () async {
                          // 게시글 수정 로직
                          print("postimage is : ${_postImageUrls}");
                          print("_selectedImages is : ${_selectedImages}");



                          await p.postUpdate(
                              _title.text,
                              _content.text,
                              _selectedCategory.id,
                              p.post.value.id!,
                              _selectedImages,
                              _postImageUrls);
                          Get.off(() => DetailPage(
                              category: _selectedCategory,
                              id: p.post.value.id!));
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
