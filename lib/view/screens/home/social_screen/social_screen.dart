import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hide_and_squeaks/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:hide_and_squeaks/view/components/custom_text/custom_text.dart';
import 'package:hide_and_squeaks/view/screens/home/social_screen/widget/custom_social_card.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../navbar/navbar.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                  top: 60.h,
                  text: "Social",
                  fontSize: 24.w,
                  fontWeight: FontWeight.w600),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: List.generate(3, (value) {
                    return CustomSocialCard();
                  }),
                ),
              )
            ],
          )
        ],
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 1,
      ),
    );
  }
}
