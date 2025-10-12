import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/core/app_routes/app_routes.dart';
import 'package:hide_and_squeaks/utils/app_const/app_const.dart';
import 'package:hide_and_squeaks/view/screens/authentication/controller/auth_controller.dart';

import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../../utils/app_strings/app_strings.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_from_card/custom_from_card.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_text/custom_text.dart';

String? provider ;

class CreateAccountScreenSocial extends StatelessWidget {

  CreateAccountScreenSocial({super.key, required provider});

  final authController = Get.put(AuthController());
  

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
                    text: AppStrings.createAccount,
                    fontSize: 35.w,
                    fontWeight: FontWeight.w600,
                    bottom: 8.h,
                  ),
                  CustomText(
                    text: AppStrings.loginAccountTitle,
                    fontSize: 16.w,
                    fontWeight: FontWeight.w400,
                    bottom: 60.h,
                  ),
                  CustomFormCard(
                    title: AppStrings.yourName,
                    hintText: AppStrings.enterYourName,
                    controller: authController.nameController,
                  ),
                  CustomFormCard(
                    title: AppStrings.location,
                    hintText: AppStrings.enteryoulocation,
                    controller: authController.locationController,
                  ),
                   CustomFormCard(
                    title: AppStrings.email,
                    hintText: AppStrings.enterYourEmail,
                    controller: authController.emailController,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (value) {},
                        checkColor: AppColors.red,
                        focusColor: AppColors.white,
                        activeColor: AppColors.white,
                      ),
                      CustomText(
                        text: AppStrings.iAgreeWith,
                        fontSize: 11.w,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Obx(() => CustomButton(
                        title: authController.isSocialSAuthLoading.value
                            ? "Creating Account..."
                            : AppStrings.signUp,
                        onTap: authController.isSocialSAuthLoading.value
                            ? () {}
                            : () {
                                authController.socialAuth(
                                    name: authController.emailController.value.text,
                                    location : authController.locationController.value.text,
                                    email: authController.emailController.value.text,
                                    photo: AppConstants.profileImage,
                                    provider: "appleAuth"
                                    );
                              },
                        fontSize: 16,
                      )),
                  SizedBox(height: 20.h),
                  Divider(thickness: .8, color: AppColors.white),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: AppStrings.haveAnyAccount,
                        fontSize: 14.w,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                        right: 10.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.loginScreen);
                        },
                        child: CustomText(
                          text: AppStrings.singInText,
                          fontSize: 14.w,
                          fontWeight: FontWeight.w400,
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
