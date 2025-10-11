import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hide_and_squeaks/view/components/custom_button/custom_button.dart';
import 'package:hide_and_squeaks/view/components/custom_from_card/custom_from_card.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_const/app_const.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_netwrok_image/custom_network_image.dart';
import '../../../components/custom_royel_appbar/custom_royel_appbar.dart';
import 'controller/edit_profile_controller.dart';
class EditProfileSetting extends StatelessWidget {
  EditProfileSetting({super.key});

  final editProfileController =Get.find<EditProfileController>();

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
              Center(
                child: Stack(
                  children: [
                    Obx(() {
// Check if an image is selected, if not use the default profile image
                      if (editProfileController.selectedImage.value != null) {
                        return Container(
                          height: 120.h,
                          width: 120.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: FileImage(editProfileController.selectedImage.value!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      } else {
                        return CustomNetworkImage(
                          imageUrl: AppConstants.profileImage,
                          height: 120.h,
                          width: 120.w,
                          boxShape: BoxShape.circle,
                        );
                      }
                    }),
                    Positioned(
                      bottom: 5,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          editProfileController.pickImageFromGallery();
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h,),
              Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                children: [
                  CustomFormCard(
                      title: "Your Name",
                      hintText: "Enter Name",
                      controller: TextEditingController()),
                  CustomFormCard(
                      title: "Phone Number",
                      hintText: "Enter Phone Number",
                      controller: TextEditingController()),
                  CustomFormCard(
                      title: "Location",
                      hintText: "Enter Location",
                      controller: TextEditingController()),
                  SizedBox(height: 80.h,),
                  CustomButton(onTap: (){}, title: "Update Profile",)
                ],
              ))

            ],
          )
        ],
      ),
    );
  }
}
