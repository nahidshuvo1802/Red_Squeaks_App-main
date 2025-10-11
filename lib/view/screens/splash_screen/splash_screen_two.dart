import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/core/app_routes/app_routes.dart';
import '../../../utils/app_images/app_images.dart';
import '../../components/custom_image/custom_image.dart';
class SplashScreenTwo extends StatelessWidget {
  const SplashScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          Get.toNamed(AppRoutes.loginScreen);
        },
        child: CustomImage(
          imageSrc: AppImages.splashScreenThree,
          boxFit: BoxFit.cover,
          fit: BoxFit.cover,
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          scale: 4,
        ),
      ),
    );
  }
}
