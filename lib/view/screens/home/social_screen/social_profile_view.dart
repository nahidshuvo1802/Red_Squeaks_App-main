import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hide_and_squeaks/utils/app_const/app_const.dart';
import 'package:hide_and_squeaks/utils/app_icons/app_icons.dart';
import 'package:hide_and_squeaks/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:hide_and_squeaks/view/components/custom_text/custom_text.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_royel_appbar/custom_royel_appbar.dart';

class SocialProfileView extends StatelessWidget {
  const SocialProfileView({super.key});

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
              CustomRoyelAppbar(
                titleName: "Profile View",
              ),
              CustomNetworkImage(
                imageUrl: AppConstants.profileImage,
                height: 100.h,
                width: 100.w,
                boxShape: BoxShape.circle,
              ),
              CustomText(
                top: 10.h,
                text: "Mehedi Bin Ab. Salam",
                fontSize: 24.w,
                fontWeight: FontWeight.w600,
              ),
              CustomText(
                text: "Bangladesh",
                fontSize: 16.w,
                fontWeight: FontWeight.w400,
              ),
              ///======================= GridView Builder ====================
              GridView.builder(
                padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 12,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Stack(
                      children: [
                        CustomNetworkImage(
                          imageUrl: AppConstants.dog,
                          height: 104.h,
                          width: 86.w,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        Positioned(
                          bottom: 4,
                          left: 10,
                          child: Row(
                            children: [
                              CustomImage(imageSrc: AppIcons.like,height: 8.h,width: 8.w,),
                              CustomText(text: "11k", fontSize: 12.w,fontWeight: FontWeight.w400,)
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          )
        ],
      ),
    );
  }
}
