import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/post_controller.dart';
import 'package:m_life_app/util/validator_util.dart';
import 'package:m_life_app/view/pages/post/detail_page.dart';
import 'package:m_life_app/view/pages/post/home_page.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_text_area.dart';
import '../../components/custom_text_form_field.dart';

class UpdatePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final PostController p = Get.find();
    _title.text = "${p.post.value.title}";
    _content.text = "${p.post.value.content}";

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
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
                      await p.postUpdate(
                          _title.text, _content.text, p.post.value.id!);
                      // Get.back();
                      Get.off(() => DetailPage(p.post.value.id!));
                    }
                  },
                )
              ],
            )),
      ),
    );
  }
}
