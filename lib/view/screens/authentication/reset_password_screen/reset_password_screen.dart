import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/utils/ToastMsg/toast_message.dart';
import 'package:hide_and_squeaks/view/screens/authentication/controller/auth_controller.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../../utils/app_strings/app_strings.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_from_card/custom_from_card.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_text/custom_text.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String userId; // ✅ required userId

  ResetPasswordScreen({
    super.key,
    required this.userId, // ✅ mark as required
  });

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

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
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: AppStrings.resetPassword,
                    fontSize: 24.w,
                    fontWeight: FontWeight.w600,
                    bottom: 8.h,
                  ),
                  CustomText(
                    text: AppStrings.loginAccountTitle,
                    fontSize: 12.w,
                    fontWeight: FontWeight.w400,
                    bottom: 150.h,
                  ),
                  CustomFormCard(
                    title: AppStrings.password,
                    hintText: AppStrings.enterYourPassword,
                    isPassword: true,
                    controller: passwordController,
                  ),
                  CustomFormCard(
                    title: AppStrings.confirmPassword,
                    hintText: "Re-${AppStrings.enterYourPassword}",
                    isPassword: true,
                    controller: confirmPasswordController,
                  ),
                  SizedBox(height: 30.h),
                  CustomButton(
                    onTap: () {
                      if (passwordController.text != confirmPasswordController.text) {
                        showCustomSnackBar("Passwords don't match!", isError: true);
                        return;
                      }

                      authController.resetPassword(
                        userId: userId, // ✅ pass userId here
                        password: confirmPasswordController.text.trim(),
                      );
                    },
                    title: AppStrings.updatePassword,
                    fontSize: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
