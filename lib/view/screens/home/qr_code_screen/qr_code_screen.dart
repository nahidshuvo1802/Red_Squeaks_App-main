import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hide_and_squeaks/utils/app_colors/app_colors.dart';
import 'package:hide_and_squeaks/utils/app_strings/app_strings.dart';
import 'package:hide_and_squeaks/view/components/custom_text/custom_text.dart';
import 'package:hide_and_squeaks/view/screens/navbar/navbar.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_image/custom_image.dart';

class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: CustomText(
                  text: AppStrings.qrCode,
                  fontSize: 24.w,
                  fontWeight: FontWeight.w600,
                  bottom: 50.h,
                )),
                CustomText(
                  text: AppStrings.qrCodeTitle,
                  fontSize: 16.w,
                  fontWeight: FontWeight.w500,
                ),
                CustomText(
                  text: AppStrings.qrCodeTitleTwo,
                  fontSize: 16.w,
                  fontWeight: FontWeight.w500,
                  color: AppColors.red,
                  bottom: 80.h,
                ),
               CustomImage(imageSrc: AppImages.qrCodeImage),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Navbar(currentIndex: 0,),
    );
  }
}
