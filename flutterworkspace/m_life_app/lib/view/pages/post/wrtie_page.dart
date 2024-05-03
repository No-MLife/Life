import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/post_controller.dart';
import 'package:m_life_app/util/validator_util.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_header_navi.dart';
import '../../components/custom_text_area.dart';
import '../../components/custom_text_form_field.dart';
import 'home_page.dart';

class WritePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();

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
                  destination: () {
                    if (_formKey.currentState!.validate()) {
                      p.postCreate(_title.text, _content.text);
                      Get.off(() => HomePage());
                    }
                  },
                )
              ],
            )),
      ),
    );
  }
}
