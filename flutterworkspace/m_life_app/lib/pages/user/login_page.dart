import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/components/custom_text_form_field.dart';
import 'package:m_life_app/pages/post/home_page.dart';
import 'package:m_life_app/util/validator_util.dart';
import '../../components/Logo.dart';
import '../../components/custom_elevated_button.dart';
import '../../size.dart';
import 'package:m_life_app/size.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: large_gap),
          Logo("로그인", "large"),
          _loginForm(),

        ],
      ),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextFormField(
              text: "ID",
              funValidator: validate_username(),
          ),
          CustomTextFormField(
              text: "Password",
              funValidator: validate_password(),
          ),
          SizedBox(height: medium_gap),
          CustomElevatedButton(
            text: "로그인",
            destination: () {
              if(_formKey.currentState!.validate())
                Get.to(() => HomePage());

            },
          ),
        ],
      ),
    );
  }
}

