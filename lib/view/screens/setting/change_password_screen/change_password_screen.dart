import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_from_card/custom_from_card.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_royel_appbar/custom_royel_appbar.dart';
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

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
                titleName: "Edit Profile",
              ),
              SizedBox(height: 20.h,),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16.0),
               child: Column(
                 children: [
                   CustomFormCard(
                       title: "Old Password",
                       hintText: "******",
                       controller: TextEditingController()),
                   CustomFormCard(
                       title: "New Password",
                       hintText: "*****",
                       controller: TextEditingController()),
                   CustomFormCard(
                       title: "Confirm Password",
                       hintText: "*****",
                       controller: TextEditingController()),
                   SizedBox(height: 80.h,),
                   CustomButton(onTap: (){}, title: "Update Password",)
                 ],
               ),
             )

            ],
          )
        ],
      ),
    );
  }
}
