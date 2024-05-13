import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    super.initState();
    final PostController p = Get.find();
    _title.text = "${p.post.value.title}";
    _content.text = "${p.post.value.content}";
    _selectedCategory = Category.values.firstWhere((category) => category.id == p.post.value.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    final PostController p = Get.find();

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
                  text: "Title",
                  funValidator: validate_title(),
                ),
                CustomTextFormArea(
                  controller: _content,
                  text: "Content",
                  funValidator: validate_content(),
                ),
                CustomElevatedButton(
                  text: "글 수정하기",
                  destination: () async {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            ConfirmationDialog(
                              title: "게시글 수정",
                              content: "게시글을 수정하시겠습니까?",
                              confirmText: "수정",
                              onConfirm: () async {
                                // 게시글 수정 로직
                                await p.postUpdate(
                                    _title.text, _content.text, _selectedCategory.id, p.post.value.id!);
                                Get.off(() => DetailPage(p.post.value.id!));
                              },
                            ),
                      );
                    }
                  },
                )
              ],
            )),
      ),
    );
  }
}