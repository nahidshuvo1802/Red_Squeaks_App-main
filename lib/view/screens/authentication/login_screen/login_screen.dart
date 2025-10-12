import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/utils/app_colors/app_colors.dart';
import 'package:hide_and_squeaks/utils/app_icons/app_icons.dart';
import 'package:hide_and_squeaks/utils/app_strings/app_strings.dart';
import 'package:hide_and_squeaks/view/components/custom_button/custom_button.dart';
import 'package:hide_and_squeaks/view/components/custom_from_card/custom_from_card.dart';
import 'package:hide_and_squeaks/view/components/custom_text/custom_text.dart';
import 'package:hide_and_squeaks/view/screens/authentication/create_account_screen/create_account_screen.dart';
import 'package:hide_and_squeaks/view/screens/authentication/create_account_screen/create_account_screen_.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_image/custom_image.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    return Scaffold(
      body: SingleChildScrollView(
        //physics: NeverScrollableScrollPhysics(),
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
                    text: AppStrings.loginAccount,
                    fontSize: 24.w,
                    fontWeight: FontWeight.w600,
                    bottom: 8.h,
                  ),
                  CustomText(
                    text: AppStrings.loginAccountTitle,
                    fontSize: 12.w,
                    fontWeight: FontWeight.w400,
                    bottom: 80.h,
                  ),
                  CustomFormCard(
                    title: AppStrings.email,
                    hintText: AppStrings.enterYourEmail,
                    controller: authController.loginEmailController,
                  ),
                  CustomFormCard(
                    title: AppStrings.password,
                    hintText: AppStrings.enterYourPassword,
                    isPassword: true,
                    controller: authController.loginPasswordController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                            text: AppStrings.rememberMe,
                            fontSize: 12.w,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.forgotPasswordScreen);
                        },
                        child: CustomText(
                          text: AppStrings.forgotPassword,
                          fontSize: 12.w,
                          fontWeight: FontWeight.w400,
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Obx(() => CustomButton(
                        onTap: authController.isLoginLoading.value? () {}: () {authController.loginUser();},
                        title: authController.isLoginLoading.value
                            ? "Logging in..."
                            : AppStrings.login,
                      fontSize: 18,
                      )
                      
                      ),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 1.h,
                        width: 110.w,
                        color: AppColors.white_50,
                      ),
                      CustomText(
                        text: AppStrings.orSignIn,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white_50,
                        left: 5.w,
                        right: 5.w,
                      ),
                      Container(
                        height: 1.h,
                        width: 110.w,
                        color: AppColors.white_50,
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          final authProvider = "appleAuth";
                          Get.to( CreateAccountScreenSocial(provider:authProvider));
                        },
                        child: CustomImage(imageSrc: AppIcons.apple)),
                      SizedBox(width: 20.w),
                      GestureDetector(
                        onTap: (){
                             final authProvider = "googleAuth";
                          Get.to( CreateAccountScreenSocial(provider:authProvider));
                        },
                        child: CustomImage(imageSrc: AppIcons.google)),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: AppStrings.dontHaveAccount,
                        fontSize: 14.w,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                        right: 10.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          final authProvider = provider;
                          Get.to( CreateAccountScreen());
                        },
                        child: CustomText(
                          text: AppStrings.signUp,
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
