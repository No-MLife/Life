import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/util/validator_util.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_text_area.dart';
import '../../components/custom_text_form_field.dart';
import 'home_page.dart';

class WritePage extends StatelessWidget {
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
                ),
                CustomTextFormArea(
                  text: "Content",
                  funValidator: validate_content(),
                ),
                CustomElevatedButton(
                  text: "글쓰기",
                  destination: () {
                    if (_formKey.currentState!.validate())
                      Get.off(() => HomePage());
                  },
                )
              ],
            )),
      ),
    );
  }
}
