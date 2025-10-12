import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hide_and_squeaks/utils/ToastMsg/toast_message.dart';
import 'package:hide_and_squeaks/view/screens/authentication/controller/auth_controller.dart';

import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_from_card/custom_from_card.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_royel_appbar/custom_royel_appbar.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CustomImage(
              imageSrc: AppImages.backgroundImage,
              boxFit: BoxFit.fill,
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              fit: BoxFit.cover,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomRoyelAppbar(
                  titleName: "Edit Profile",
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      CustomFormCard(
                        title: "Old Password",
                        hintText: "******",
                        controller: controller.oldPassword,
                        isPassword: true,
                      ),
                      CustomFormCard(
                        title: "New Password",
                        hintText: "*****",
                        controller: controller.newPassword,
                        isPassword: true,
                      ),
                      CustomFormCard(
                          isPassword: true,
                          title: "Confirm Password",
                          hintText: "*****",
                          controller: controller.confirmNewPassword),
                      SizedBox(
                        height: 80.h,
                      ),

                      Obx(() =>
                        CustomButton(
                          onTap: () {
                            if (controller.newPassword.text !=
                                controller.confirmNewPassword.value.text) {
                              showCustomSnackBar("Passwords Doesn't Match");
                            }
                            controller.changePassword(
                                oldPassword:
                                    controller.oldPassword.value.text.toString(),
                                newPassword:
                                    controller.newPassword.value.text.toString());
                          },
                          title: controller.isChangePasswordLoading == false
                              ? "Update Password"
                              : "Updating Password...",
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
