import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/util/validator_util.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_text_area.dart';
import '../../components/custom_text_form_field.dart';

class UpdatePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                CustomTextFormField(
                  text: "Title",
                  funValidator: validate_title(),
                  value: "제목 1",
                ),
                CustomTextFormArea(
                  text: "Content",
                  funValidator: validate_content(),
                  value: "글 내용 1",
                ),
                CustomElevatedButton(
                  text: "글 수정하기",
                  destination: () {
                    if (_formKey.currentState!.validate()) Get.back();
                  },
                )
              ],
            )),
      ),
    );
  }
}
