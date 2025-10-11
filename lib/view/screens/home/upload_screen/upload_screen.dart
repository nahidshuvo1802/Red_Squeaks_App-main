import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hide_and_squeaks/utils/app_colors/app_colors.dart';
import 'package:hide_and_squeaks/utils/app_icons/app_icons.dart';
import 'package:hide_and_squeaks/view/components/custom_button/custom_button.dart';
import 'package:hide_and_squeaks/view/components/custom_text/custom_text.dart';
import 'package:hide_and_squeaks/view/components/custom_text_field/custom_text_field.dart';

import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../navbar/navbar.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

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
                  text: "Upload Video",
                  fontSize: 24.w,
                  fontWeight: FontWeight.w600),
              SizedBox(
                height: 50.h,
              ),
              Expanded(
                  child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1)),
                    child: Column(
                      children: [
                        CustomImage(imageSrc: AppIcons.videoIcon),
                        CustomText(
                          top: 10,
                          text: "Drag & Drop or choose file to upload",
                          fontSize: 14.w,
                          fontWeight: FontWeight.w400,
                          bottom: 8,
                        ),
                        CustomText(
                          text: "Select Video",
                          fontSize: 14.w,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      top: 20.h,
                      text: "Video Tittle",
                      fontSize: 16.w,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  CustomTextField(
                    maxLines: 6,
                    fillColor: Colors.transparent,
                    fieldBorderColor: AppColors.white,
                    fieldBorderRadius: 10,
                    hintText: "Enter Your Video Tittle",
                  ),
                  SizedBox(height: 50.h,),
                  CustomButton(onTap: (){}, title: "Upload",)
                ],
              ))
            ],
          )
        ],
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 2,
      ),
    );
  }
}
