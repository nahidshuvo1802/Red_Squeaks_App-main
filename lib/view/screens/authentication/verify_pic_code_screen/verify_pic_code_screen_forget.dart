import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/utils/app_colors/app_colors.dart';
import 'package:hide_and_squeaks/view/components/custom_pin_code/custom_pin_code.dart';
import 'package:hide_and_squeaks/view/screens/authentication/controller/auth_controller.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../../utils/app_strings/app_strings.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_text/custom_text.dart';

class VerifyPicCodeScreenForget extends StatelessWidget {
  const VerifyPicCodeScreenForget({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

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
                    text: AppStrings.verifyAccount,
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
                 
                  Center(
                    child: Column(
                      children: [
                        CustomText(
                          text: AppStrings.enter4Digits,
                          fontSize: 30.w,
                          fontWeight: FontWeight.w600,
                        ),
                        CustomText(
                          text: "${AppStrings.enter4DigitsTitle} to Reset Password",
                          fontSize: 14.w,
                          fontWeight: FontWeight.w400,
                          maxLines: 2,
                          bottom: 30.h,
                        ),
                      ],
                    ),
                  ),
        
                  CustomPinCode(controller: authController.otpController),
                  SizedBox(height: 20.h),
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: AppStrings.iDidntFind,
                        fontSize: 14.w,
                        fontWeight: FontWeight.w400,
                        right: 6.w,
                      ),

                      GestureDetector(
                        onTap: ()=> authController.verifyOtp() ,
                        child: CustomText(
                          text: AppStrings.sendAgain,
                          fontSize: 14.w,
                          fontWeight: FontWeight.w400,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 80.h),
        
                  Obx(() => CustomButton(
                        title: authController.isOtpVerifying.value
                            ? "Verifying..."
                            : AppStrings.confirm,
                        onTap: authController.isOtpVerifying.value
                            ? () => Get.snackbar("Failed","OTP is missing")
                            : () {
                                authController.verifyOtpForget();
                              },
                      fontSize: 16,
                      )
                      ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
