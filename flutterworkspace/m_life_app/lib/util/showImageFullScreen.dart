import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/user_controller.dart';

final UserController _userController = Get.find();

void showImageFullScreen(BuildContext context) {
  if (_userController.profile.value.profileImageUrl != null) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage(
                    _userController.profile.value.profileImageUrl!),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}
