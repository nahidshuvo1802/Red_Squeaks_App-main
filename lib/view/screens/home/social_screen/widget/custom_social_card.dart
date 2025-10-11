import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/core/app_routes/app_routes.dart';
import '../../../../../utils/app_const/app_const.dart';
import '../../../../../utils/app_icons/app_icons.dart';
import '../../../../components/custom_image/custom_image.dart';
import '../../../../components/custom_netwrok_image/custom_network_image.dart';
import '../../../../components/custom_text/custom_text.dart';
class CustomSocialCard extends StatelessWidget {
  const CustomSocialCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Stack(
        children: [
          CustomNetworkImage(
            borderRadius: BorderRadius.circular(20),
            imageUrl: AppConstants.dog,
            height: MediaQuery.sizeOf(context).height / 2,
            width: MediaQuery.sizeOf(context).width,
          ),
          Positioned(
              bottom: 20,
              left: 10,
              child: GestureDetector(
                onTap: (){
                  Get.toNamed(AppRoutes.socialProfileView);
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomNetworkImage(
                          imageUrl: AppConstants.profileImage,
                          height: 50.h,
                          width: 50.w,
                          boxShape: BoxShape.circle,
                        ),
                        SizedBox(width: 10.w,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Mededi Bin Ab. Salam",
                              fontSize: 16.w,
                              fontWeight: FontWeight.w500,
                            ),
                            CustomText(
                              text: "3d Ago",
                              fontSize: 12.w,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        )
                      ],
                    ),
                    CustomText(text: "Look at My Adorable Pet! 🎥😍",fontSize: 14.w,fontWeight: FontWeight.w600,)
                  ],
                ),
              )),
          Positioned(
              bottom: 60,
              right: 16,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent.withValues(alpha: .1), // Halka background color
                      shape: BoxShape.circle, // Jodi round button chai
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: CustomImage(imageSrc: AppIcons.like),
                    ),
                  ),
                  CustomText(text: "1.7k", fontSize: 14.w,fontWeight: FontWeight.w600,),
                  SizedBox(height: 10.h,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent.withValues(alpha: .1), // Halka background color
                      shape: BoxShape.circle, // Jodi round button chai
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: CustomImage(imageSrc: AppIcons.unlike),
                    ),
                  ),
                  CustomText(text: "100", fontSize: 14.w,fontWeight: FontWeight.w600,),
                  SizedBox(height: 10.h,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent.withValues(alpha: .1), // Halka background color
                      shape: BoxShape.circle, // Jodi round button chai
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: CustomImage(imageSrc: AppIcons.share),
                    ),
                  ),
                  CustomText(text: "100", fontSize: 14.w,fontWeight: FontWeight.w600,)
                ],
              ))
        ],
      ),
    );
  }
}
